-- ödünç alındığında azalan
CREATE OR REPLACE TRIGGER trg_stok_azalt
AFTER INSERT ON emanetler
FOR EACH ROW
BEGIN
    BEGIN
        UPDATE kitaplar
        SET stok_sayisi = stok_sayisi - 1
        WHERE kitap_id = :NEW.kitap_id;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Hata oluştu: ' || SQLERRM);
    END;
END;



-- iade edildiğinde artan
CREATE OR REPLACE TRIGGER trg_stok_artir
AFTER UPDATE OF teslim_tarihi ON emanetler
FOR EACH ROW
WHEN (OLD.teslim_tarihi IS NULL AND NEW.teslim_tarihi IS NOT NULL)
BEGIN
    UPDATE kitaplar
    SET stok_sayisi = stok_sayisi + 1
    WHERE kitap_id = :NEW.kitap_id;
END;


-- geç iade
CREATE OR REPLACE TRIGGER trg_gec_iade
AFTER UPDATE OF teslim_tarihi ON emanetler
FOR EACH ROW
WHEN (OLD.teslim_tarihi IS NULL AND NEW.teslim_tarihi IS NOT NULL)
DECLARE
    v_bugun DATE := TRUNC(SYSDATE);
BEGIN
    IF :NEW.teslim_tarihi > v_bugun THEN
        INSERT INTO gec_iadeler (emanet_id, kitap_id, uye_id, gecikme_tarihi, aciklama)
        VALUES (:NEW.emanet_id, :NEW.kitap_id, :NEW.uye_id, :NEW.teslim_tarihi, 'Geç teslim edildi.');
    END IF;
END;
