DROP EVENT IF EXISTS drop_expired_measures_nightly;

CREATE EVENT drop_expired_measures_nightly
ON SCHEDULE EVERY 1 DAY
STARTS '2024-08-26 00:00:00'
DO
BEGIN
    CALL drop_expired_measures();
END;
