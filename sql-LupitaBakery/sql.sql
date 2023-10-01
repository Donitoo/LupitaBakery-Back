CREATE OR REPLACE PACKAGE My_Procedures AUTHID CURRENT_USER IS
  SUBTYPE MONEY IS NUMBER(10,4);
  SUBTYPE QUANTITY IS NUMBER(5);
  SUBTYPE WORD IS VARCHAR2(120);
  TYPE AA_BREAD_TYPE IS TABLE OF WORD INDEX BY PLS_INTEGER;
  TYPE AA_BREAD_QUANTITY IS TABLE OF QUANTITY INDEX BY PLS_INTEGER;
  FUNCTION iniciar_sesion(mail WORD,pwd WORD) RETURN BOOLEAN;
  PROCEDURE new_order(id IN NUMBER,bread_type IN AA_BREAD_TYPE,amount IN AA_BREAD_QUANTITY);
  PROCEDURE new_return(id IN NUMBER,bread_type IN AA_BREAD_TYPE,amount IN AA_BREAD_QUANTITY);
END My_Procedures;
/

PROCEDURE new_order(id IN NUMBER,bread_type IN AA_BREAD_TYPE,amount IN AA_BREAD_QUANTITY) IS
    order_discount MONEY;
    bread_price MONEY;
    total_price MONEY := 0;
    orden_id NUMBER;
    pan_id NUMBER;
    qnt QUANTITY := 0;
    i NUMBER;
  BEGIN
    SELECT discount INTO order_discount FROM Client WHERE client_id=id;
    i := amount.FIRST;
    WHILE i IS NOT NULL LOOP
        qnt := qnt + amount(i);
        SELECT price INTO bread_price FROM Bread WHERE type=bread_type(i);
        total_price := total_price + (amount(i) * bread_price); 
        i := amount.NEXT(i);
    END LOOP;
    INSERT INTO Orden (client_id,bread_quantity,total,discount,final_price) VALUES (id,qnt,total_price,order_discount,total_price - order_discount) RETURNING order_id INTO orden_id;
    i := amount.FIRST;
    WHILE i IS NOT NULL LOOP
        SELECT price,bread_id INTO bread_price,pan_id FROM Bread WHERE type=bread_type(i);
        INSERT INTO Order_item(order_id,bread_id,bread_quantity,subtotal) VALUES (orden_id,pan_id,amount(i),amount(i)*bread_price);
        i := amount.NEXT(i);
    END LOOP;
    COMMIT WRITE IMMEDIATE NOWAIT;
  EXCEPTION 
    WHEN OTHERS THEN
        ROLLBACK;
  END;