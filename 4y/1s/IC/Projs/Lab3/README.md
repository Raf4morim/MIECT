Lab3

In a terminal, enter the **build** directory of your project
```
mkdir build && cd build
```
Then compile the code
```
cmake ..
make
```

# How to compile:

Go to the diretory with make file -> ./Lab3/
### 1:
    Execute
    > make
    > <bin path> <k> <alpha> <text file path>
    Exemplo: fcm-example-bin/fcm  5 0.3 fcm-example-src/part1/textos/Quijote.txt

### 2:
    Execute
    > make
    > <bin path> <k> <alpha> <reference text file path> <analysis text file path>
    Exemplo: ./fcm-example-bin/test_lang  5 0.5 fcm-example-src/exemplos/es.txt fcm-example-src/textos/randomPt.txt

### 3:
    Execute
    > make
    > <bin path> <k> <alpha>
    Exemplo: fcm-example-bin/test_findlang 3 0.5

    Then answer the inputs firstly with the name file and after that y/n to continue. 
