-- yeni kitap ekleme
CREATE OR REPLACE PROCEDURE kitap_ekle (
    p_ad        IN VARCHAR2,
    p_yazar     IN VARCHAR2,
    p_yayinevi  IN VARCHAR2,
    p_stok      IN NUMBER
)
IS
BEGIN
    INSERT INTO kitaplar (ad, yazar, yayinevi, stok_sayisi)
    VALUES (p_ad, p_yazar, p_yayinevi, p_stok);
END;

-- yeni üye ekleme
CREATE OR REPLACE PROCEDURE uye_ekle (
    p_ad     IN VARCHAR2,
    p_soyad  IN VARCHAR2,
    p_email  IN VARCHAR2
)
IS
BEGIN
    INSERT INTO uyeler (ad, soyad, email)
    VALUES (p_ad, p_soyad, p_email);
END;

-- kitap ödünç verme /7 gün kuarlı burada
CREATE OR REPLACE PROCEDURE kitap_odunc_ver (
    p_kitap_id IN NUMBER,
    p_uye_id   IN NUMBER
)
IS
    v_stok      NUMBER := 0;
    v_oduncte   NUMBER := 0;
    v_kalan     NUMBER := 0;
    v_son_teslim DATE;
BEGIN
    SELECT stok_sayisi INTO v_stok
    FROM kitaplar
    WHERE kitap_id = p_kitap_id;

    SELECT COUNT(*) INTO v_oduncte
    FROM emanetler
    WHERE kitap_id = p_kitap_id AND teslim_tarihi IS NULL;

    v_kalan := v_stok - v_oduncte;

    -- Kullanıcının aynı kitabı 7 gün içinde yeniden alması engelleniyor, sadece iade edilenler dikkate alınıyor
    SELECT MAX(teslim_tarihi) INTO v_son_teslim
    FROM emanetler
    WHERE kitap_id = p_kitap_id AND uye_id = p_uye_id AND teslim_tarihi IS NOT NULL;
    

    IF v_son_teslim IS NOT NULL AND SYSDATE - v_son_teslim < 7 THEN
        DBMS_OUTPUT.PUT_LINE('Bu kitabı tekrar alabilmeniz için en az 7 gün beklemelisiniz.');
        RETURN;
    END IF;

    IF v_kalan > 0 THEN
        INSERT INTO emanetler (kitap_id, uye_id, alis_tarihi)
        VALUES (p_kitap_id, p_uye_id, SYSDATE);
        DBMS_OUTPUT.PUT_LINE('Kitap başarıyla ödünç verildi.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Kitap stokta yok. Ödünç verilemez.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Kitap veya üye bulunamadı.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Hata: ' || SQLERRM);
END;

-- kitap iade etme
CREATE OR REPLACE PROCEDURE kitap_iade_et (
    p_emanet_id IN NUMBER
)
IS
    v_teslim_tarihi DATE;
BEGIN
    SELECT teslim_tarihi INTO v_teslim_tarihi
    FROM emanetler
    WHERE emanet_id = p_emanet_id;

    IF v_teslim_tarihi IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Kitap zaten teslim edilmiş.');
        RETURN;
    END IF;

    UPDATE emanetler
    SET teslim_tarihi = SYSDATE
    WHERE emanet_id = p_emanet_id;

    DBMS_OUTPUT.PUT_LINE('İade işlemi başarılı.');
END;

-- 15 gün uyarısı
CREATE OR REPLACE PROCEDURE uyar_15gun_emanet
IS
BEGIN
    FOR emanet IN (
        SELECT e.emanet_id, u.ad || ' ' || u.soyad AS uye_adi, k.ad AS kitap_adi,
               e.alis_tarihi, SYSDATE - e.alis_tarihi AS gun_sayisi
        FROM emanetler e
        JOIN uyeler u ON e.uye_id = u.uye_id
        JOIN kitaplar k ON e.kitap_id = k.kitap_id
        WHERE e.teslim_tarihi IS NULL AND SYSDATE - e.alis_tarihi > 15
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('UYARI: ' || emanet.uye_adi || ' - "' || emanet.kitap_adi || '" kitabı ' || emanet.gun_sayisi || ' gündür teslim edilmedi!');
    END LOOP;
END;

