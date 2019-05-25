valgrind --tool=cachegrind -v --I1=16384,2,64 --D1=16384,4,64 --LL=524288,16,64 --branch-sim=yes --cachegrind-out-file=./valgrind-out/cachegrind-out-rsa ./rsa
valgrind --tool=cachegrind -v --I1=16384,2,64 --D1=16384,4,64 --LL=524288,16,64 --branch-sim=yes --cachegrind-out-file=./valgrind-out/cachegrind-out-rsa-ref ./rsa-ref
valgrind --tool=cachegrind -v --I1=16384,2,64 --D1=16384,4,64 --LL=524288,16,64 --branch-sim=yes --cachegrind-out-file=./valgrind-out/cachegrind-out-rsa-cmethods ./rsa-cmethods
cg_diff ./valgrind-out/cachegrind-out-rsa-ref ./valgrind-out/cachegrind-out-rsa >> ./valgrind-out/diff-rsa-ref
cg_diff ./valgrind-out/cachegrind-out-rsa-cmethods ./valgrind-out/cachegrind-out-rsa >> ./valgrind-out/diff-rsa-cmethods