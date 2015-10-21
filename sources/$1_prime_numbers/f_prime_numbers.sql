CREATE OR REPLACE TYPE PRIMES IS VARRAY (200) OF INTEGER;


CREATE OR REPLACE FUNCTION generate_prime_factors(p_num INTEGER)
  RETURN PRIMES IS
  the_primes PRIMES := PRIMES();
  n          INTEGER := p_num;
  candidate  INTEGER := 2;
  PROCEDURE append(arr IN OUT PRIMES, elem IN INTEGER) IS
    BEGIN
      arr.EXTEND();
      arr(arr.COUNT) := elem;
    END append;
  BEGIN
    WHILE (n > 1) LOOP
      WHILE (MOD(n, candidate) = 0) LOOP
        append(the_primes, candidate);
        n := n / candidate;
      END LOOP;
      candidate := candidate + 1;
    END LOOP;
    RETURN the_primes;
  END;
/
