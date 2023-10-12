#include "Golomb.cpp"
#include<iostream>


static void print_MSB2LSB_in_Bin(char byte[], int numbits){
    printf("Encoded Value: ");
    for (int i = 0; i <numbits ; i++){
        printf("%d", byte[i]);
    }
    printf("\n");
}

int main(){
    //Get m and n
    int m, n;
    cout << "Insert m: ";
    cin >> m;
    cout << "Insert n: ";
    cin >> n;

    Golomb gb("t.bin", 'e', m);         //Inicializa para valores encode, objetos golomb
    
    int size = gb.encode(n);            // Codifica n
    gb.close();
    
    BitStream bs("t.bin", 'r');
    char byte[size+1];    
    bs.readNbits(byte, size+1);
    print_MSB2LSB_in_Bin(byte, size);
    bs.close();

    Golomb g("t.bin", 'd', m);          //Inicializa para valores decode, objetos golomb 
    cout << "Decoder Value: " << g.decode() << endl; //Descodifica o valor
    g.close();
    
    return 0;
}

