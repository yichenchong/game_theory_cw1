build: validator

validator:
    gcc -shared -o validator.so validator/validator.c