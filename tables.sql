CREATE TABLE kitaplar (
    kitap_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ad           VARCHAR2(100),
    yazar        VARCHAR2(100),
    yayinevi     VARCHAR2(100),
    stok_sayisi  NUMBER DEFAULT 1
);

CREATE TABLE uyeler (
    uye_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ad       VARCHAR2(50),
    soyad    VARCHAR2(50),
    email    VARCHAR2(100)
);

CREATE TABLE emanetler (
    emanet_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kitap_id       NUMBER REFERENCES kitaplar(kitap_id),
    uye_id         NUMBER REFERENCES uyeler(uye_id),
    alis_tarihi    DATE DEFAULT SYSDATE,
    teslim_tarihi  DATE
);

CREATE TABLE gec_iadeler (
    id              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    emanet_id       NUMBER,
    kitap_id        NUMBER,
    uye_id          NUMBER,
    gecikme_tarihi  DATE,
    aciklama        VARCHAR2(100)
);
