BEGIN
KITAP_ODUNC_VER(21, 3); -- 3: üyenin uye_id'si, 21: kitabın kitap_id'si
END;

BEGIN
    KITAP_IADE_ET(7);
END;

BEGIN
UYAR_15GUN_EMANET;
END;

BEGIN
  KITAP_EKLE('Kitap', 'Deneme', 'Can Yayınları', 4); -- kitap ekle
END;











-- SELECT stok_sayisi FROM kitaplar WHERE kitap_id = 63;
