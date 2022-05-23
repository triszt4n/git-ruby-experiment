# Feladat

Két, nem közvetlenül egymást követő, git commit id-je alapján
határozza meg bináris kereséssel annak a két megadott commit
között levő commitnak az id-jét, ahol a cége fejlesztői
elrontották a VS-ban írt C++ programjukat. A hibát arról lehet
megismerni, hogy a filters állományban az egyik konfliktus
feloldása során kimarad egy `</ItemData>` lezáró tag.

## Megoldás

Szükséges a futtatáshoz: 

* Ruby futtatókörnyezet 2.x vagy 3.x verzióval
* Git CLI

A megoldás a `script.rb` Ruby script fájlban található. A 
repositoryban találhatóak commitok, amelyek a test-folder 
tartalmát változtatgatják. 

A script tulajdonképpen git parancsokat futtat a háttérben. A
megfelelő git parancsokkal kigyűjti a commit hasheket, majd a
keresési intervallumban bináris kereséssel végigmegy a commitokon,
minden commitnál a `test-folder/filters` fájlnak kivizsgálja a 
`git show` paranccsal a commitok alatti állapotát, belekeres a fájlba,
megfelelő-e a tag-ek lezáró és nyitó számossága, eszerint megy
megy tovább a megfelelő félre a commit tömbben a keresés.

A hibás commit előkeresésére egy jó
teszt lehet a következő válaszokkal való kitöltése a kérdéseknek,
amint az ember elindítja a scriptet:

```sh
Enter younger git commit id:
212e328d6f1f2f71ec3b8d5df340495dbb7ea68f
Enter older git commit id:
6fbacc6512005d4061a0fe233702f578f809a889
```

A válasz ez kell legyen:

```sh
Faulty commit: 20b96ef6b01d11d8e804511fc14f5ad42789624b | Changes in filter - ERROR HERE
Run 'git --no-pager show 20b96ef6b01d11d8e804511fc14f5ad42789624b:test-folder/filters' to show faulty file content.
Binary search successfully run with 5 steps, on an array with the length of 15.
```

Még egy példa:

```sh
Enter younger git commit id:
9c4d32a844be64e3b29965bd736b472fb5eaeab1
Enter older git commit id:
bf69d67833e4e4dbafe9a973b53ebc17d447d721
```

A válasz ez kell legyen:

```sh
Faulty commit: 20b96ef6b01d11d8e804511fc14f5ad42789624b | Changes in filter - ERROR HERE
Run 'git --no-pager show 20b96ef6b01d11d8e804511fc14f5ad42789624b:test-folder/filters' to show faulty file content.
Binary search successfully run with 4 steps, on an array with the length of 10.
```
