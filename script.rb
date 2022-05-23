#!/usr/bin/ruby

def file_path
  'test-folder/filters'
end

def validate_file_in_commit(commit_hash)
  content = `git --no-pager show #{commit_hash}:#{file_path}`
  return true if content.index('fatal')&.zero?

  opening_tag_count = content.scan(/(?=<ItemData>)/).count
  closing_tag_count = content.scan(%r{(?=</ItemData>)}).count
  opening_tag_count == closing_tag_count
end

$steps = 0
def binary_search(array)
  $steps += 1
  return array[0] if array.length == 1

  middle_index = array.length / 2
  if validate_file_in_commit(array[middle_index])
    binary_search(array[0...middle_index])
  else
    binary_search(array[middle_index...array.length])
  end
end

# getting input parameters
puts 'Enter younger git commit id:'
top_hash = gets.chomp.to_s
puts 'Enter older git commit id:'
bottom_hash = gets.chomp.to_s
puts ''

# discovering the faulty commit
commit_hash_array = `git --no-pager log --pretty="%H"`.split
top_commit_index = commit_hash_array.index(top_hash)
bottom_commit_index = commit_hash_array.index(bottom_hash)
unless top_commit_index
  puts 'ERROR Invalid latter commit id: not found'
  return
end
unless bottom_commit_index
  puts 'ERROR Invalid preceding commit id: not found'
  return
end

commit_hash_array = commit_hash_array[top_commit_index..bottom_commit_index]
unless commit_hash_array.length > 2
  puts 'ERROR Commits are too close to each other'
  return
end

faulty_commit_hash = binary_search(commit_hash_array)
puts "Faulty commit: #{`git log --format="%H | %s" -n 1 #{faulty_commit_hash}`}"
puts "Run 'git --no-pager show #{faulty_commit_hash}:#{file_path}' to show faulty file content."
puts "Binary search successfully run with #{$steps} steps, on an array with the length of #{commit_hash_array.length}."
