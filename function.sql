-- üyenin aldığı kitap sayısı
CREATE OR REPLACE FUNCTION kitap_sayisi_uye (
    p_uye_id IN NUMBER
) RETURN NUMBER
IS
    v_sayi NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_sayi
    FROM emanetler
    WHERE uye_id = p_uye_id;

    RETURN v_sayi;
END;

-- stokta kalan kitap sayısı
CREATE OR REPLACE FUNCTION kalan_stok (
    p_kitap_id IN NUMBER
) RETURN NUMBER
IS
    v_stok NUMBER;
    v_oduncte NUMBER;
BEGIN
    SELECT stok_sayisi INTO v_stok FROM kitaplar WHERE kitap_id = p_kitap_id;
    SELECT COUNT(*) INTO v_oduncte FROM emanetler WHERE kitap_id = p_kitap_id AND teslim_tarihi IS NULL;

    RETURN v_stok - v_oduncte;
END;CREATE OR REPLACE FUNCTION KITAP_STOK (
    p_kitap_id NUMBER
) RETURN NUMBER IS
    v_stok NUMBER;
BEGIN
    SELECT STOK_ADEDI INTO v_stok FROM KITAPLAR WHERE KITAP_ID = p_kitap_id;
    RETURN v_stok;
END;
