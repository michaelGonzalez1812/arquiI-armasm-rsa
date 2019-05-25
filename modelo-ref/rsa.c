#include <stdio.h>
#include <stdlib.h>
#include <string.h>

__int128 phi (__int128 p, __int128 q) {
    return (p-1)*(q-1);
}

__int128 mcd(__int128 num1, __int128 num2) {
    __int128 aux, result = 1, divisor = 2;

    if (num1 > num2) {
        aux = num2;
        num2 = num1;
        num1 = aux;
    }

    do {
        if (num1%divisor == 0 && num2%divisor == 0) {
            result = result * divisor;
            num1 = num1 / divisor; 
            num2 = num2 / divisor;
            divisor = 2;
        }
        else 
            divisor++;
    } while(divisor <= num1);

    return result;
}

__int128 publickey(__int128 phi) {
    __int128 key = 1;
    __int128 mcd_result;

    do {
        key++;
        mcd_result = mcd(key, phi);
    } while (mcd_result != 1 && key < phi);
    
    return key;
}

__int128 privatekey(__int128 phi, __int128 public_key) {
    __int128 key = 0;
    __int128 mod = 0;
    do
    {
        key++;
        mod = (key*public_key) % phi;
    } while (mod != 1);
    return key;
}

__int128 exponent(__int128 base, __int128 exponentt) {
    __int128 result = base;
    __int128 i;
    for(i=1; i < exponentt; i++) {
        result = result * base;
    }
    return result;
}

__int128 encrypt(__int128 msg, __int128 public_key, __int128 n) {
    return exponent(msg, public_key) % n;
}

int main(void)
{
    char buffer[16];
    __int128 p = 0;
    __int128 q = 0;
    __int128 msg = 0;
    __int128 msgEncrypted = 0;
    __int128 msgDecrypted = 0;
    __int128 vphi = 0;
    __int128 vprivateKey = 0;
    __int128 vpublicKey = 0;
    __int128 n = 0;

    const char* pfileName = "/home/mikepi/rsa/iofiles/pfile";
    const char* qfileName = "/home/mikepi/rsa/iofiles/qfile";
    const char* nfileName = "/home/mikepi/rsa/iofiles/nfile";
	const char* msgfileName = "/home/mikepi/rsa/iofiles/msgfile";
    const char* msgEncryptedfileName = "/home/mikepi/rsa/iofiles/msgEncryptedfile";
	const char* msgDecryptedfileName = "/home/mikepi/rsa/iofiles/msgDecryptedfile";
	const char* privateKfileName = "/home/mikepi/rsa/iofiles/privateKfile";
	const char* publicKfileName = "/home/mikepi/rsa/iofiles/publicKfile";

    FILE* file;
    
    file = fopen(pfileName, "r");
    fread(&p, sizeof(__int128), 1, file);
    fclose(file);

    file = fopen(qfileName, "r");
    fread(&q, sizeof(__int128), 1, file);
    fclose(file);
    
    file = fopen(msgfileName, "r");
    fread(&msg, sizeof(__int128), 1, file);
    fclose(file);
    
    n = p*q;
    vphi = phi(p, q);
    vpublicKey = publickey(vphi);
    vprivateKey = privatekey(vphi, vpublicKey);
    msgEncrypted = encrypt(msg, vpublicKey, n);
    msgDecrypted = encrypt(msgEncrypted, vprivateKey, n);

    file = fopen(msgEncryptedfileName, "wb");
    fwrite(&msgEncrypted, sizeof(__int128), 1, file);
    fclose(file);

    file = fopen(msgDecryptedfileName, "wb");
    fwrite(&msgDecrypted, sizeof(__int128), 1, file);
    fclose(file);

    file = fopen(privateKfileName, "wb");
    fwrite(&vprivateKey, sizeof(__int128), 1, file);
    fclose(file);

    file = fopen(publicKfileName, "wb");
    fwrite(&vpublicKey, sizeof(__int128), 1, file);
    fclose(file);

    file = fopen(nfileName, "wb");
    fwrite(&n, sizeof(__int128), 1, file);
    fclose(file);

    return 0;
}
