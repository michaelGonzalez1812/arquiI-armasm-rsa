import binascii

def main():
    with open('/home/mikepi/rsa/iofiles/pfile', 'rb') as f:
        hexdata = binascii.hexlify(f.read())
    print("valor de p:          ", hexdata[0:32])

    with open('/home/mikepi/rsa/iofiles/qfile', 'rb') as f:
        hexdata = binascii.hexlify(f.read())
    print("valor de q:          ", hexdata[0:32])

    with open('/home/mikepi/rsa/iofiles/nfile', 'rb') as f:
        hexdata = binascii.hexlify(f.read())
    print("Valor de n:          ", hexdata[0:32])

    with open('/home/mikepi/rsa/iofiles/publicKfile', 'rb') as f:
        hexdata = binascii.hexlify(f.read())
    print("Clave publica:       ", hexdata[0:32])

    with open('/home/mikepi/rsa/iofiles/privateKfile', 'rb') as f:
        hexdata = binascii.hexlify(f.read())
    print("Clave privada:       ", hexdata[0:32])

    with open('/home/mikepi/rsa/iofiles/msgfile', 'rb') as f:
        hexdata = binascii.hexlify(f.read())        
    print("msg original:        ", hexdata[0:32])

    with open('/home/mikepi/rsa/iofiles/msgEncryptedfile', 'rb') as f:
        hexdata = binascii.hexlify(f.read())        
    print("msg encriptado:      ", hexdata[0:32])

    with open('/home/mikepi/rsa/iofiles/msgDecryptedfile', 'rb') as f:
        hexdata = binascii.hexlify(f.read())        
    print("msg desencriptado:   ", hexdata[0:32])
main()