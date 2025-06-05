-- ödünç alma
BEGIN
UYE_EKLE('Simay','Parlak','simayp'); -- üye ekle
END;

BEGIN
KITAP_EKLE('Gümüş Kanat', 'Cahit Uçuk', 'Hayat Yayınları', 7); -- kitap ekle
END;

BEGIN
KITAP_ODUNC_VER(4, 25); -- 25: üyenin uye_id'si, 4: kitabın kitap_id'si
END;

BEGIN
KITAP_IADE_ET(1);
END;

BEGIN
KITAP_IADE_ET(2);
END;

--  aynı üyenin aynı kitabı ikinci kez ödünç alması
BEGIN
KITAP_ODUNC_VER(4, 25); -- 25: üyenin uye_id'si, 4: kitabın kitap_id'si
END;

-- teslim
BEGIN
KITAP_IADE_ET(5); -- emanet id
END;

--  aynı üyenin aynı kitabı ikinci kez ödünç alması
BEGIN
KITAP_ODUNC_VER(4, 25); -- 25: üyenin uye_id'si, 4: kitabın kitap_id'si
END;


BEGIN
UYAR_15GUN_EMANET;
END;




SELECT * FROM kitaplar WHERE ad = 'Yeni Kitap';







BEGIN
UYE_EKLE('Deniz','Derya','denizderya'); -- üye ekle
END;

BEGIN
KITAP_EKLE('Sevda Yelleri', 'Sema Pamuk', 'Hayat Yayınları', 2); -- kitap ekle
END;




