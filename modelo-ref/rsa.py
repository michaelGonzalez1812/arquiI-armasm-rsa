
def mcd(a, b):
	resto = 0
	while(b > 0):
		resto = b
		b = a % b
		a = resto
	return a

def main():
    p = long(raw_input("Escoja un valor de 'p'=  "))
    q = long(raw_input("Escoja un valor de 'q'=  "))

    n = p * q
    print("el valor de n es: ", n)

    phi = (q - 1) * (p - 1)
    print("el valor de phi es: ", phi)

    posiblePublicKeys = filter(lambda x: (mcd(x, phi) == 1) , range(2, phi))
    print("posibles claves publicas:  ", posiblePublicKeys)
    e = long(raw_input("Escoja una =  "))

    N = long(raw_input("Escoja el numero que desea encriptar =  "))

    C = (N**e) % n
    print("Numero encriptado =", C)

    posiblePrivedKeys = filter(lambda x: (x*e) % phi == 1, range(1, 200))
    print("posibles claves privadas:  ", posiblePrivedKeys)

    for x in posiblePrivedKeys:
        N = (C**x) % n
        print("numero decriptado con clave: ", x, "N= ", N)
main()
