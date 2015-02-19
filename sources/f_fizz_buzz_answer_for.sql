CREATE OR REPLACE FUNCTION fizz_buzz_answer_for( p_num INTEGER ) RETURN VARCHAR2 IS
  FUNCTION is_fizz(p_num INTEGER) RETURN BOOLEAN IS BEGIN RETURN MOD(p_num, 3) = 0; END;
  FUNCTION is_buzz(p_num INTEGER) RETURN BOOLEAN IS BEGIN RETURN MOD(p_num, 5) = 0; END;
  FUNCTION get_fizz(p_num INTEGER) RETURN VARCHAR2 IS BEGIN RETURN CASE WHEN is_fizz(p_num) THEN 'Fizz' END; END;
  FUNCTION get_buzz(p_num INTEGER) RETURN VARCHAR2 IS BEGIN RETURN CASE WHEN is_buzz(p_num) THEN 'Buzz' END; END;
  FUNCTION get_num(p_num INTEGER) RETURN VARCHAR2 IS BEGIN RETURN CASE WHEN NOT (is_fizz(p_num) OR is_buzz(p_num) ) THEN TO_CHAR(p_num) END; END;
BEGIN
  RETURN get_fizz(p_num)||get_buzz(p_num)||get_num(p_num);
END;
/