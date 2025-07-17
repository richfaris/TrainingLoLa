/*
   bc_excel_link function

   used to build out Excel HYPERLINKs for reports

   takes a relative url and link text and returns the Excel formula
   to create a HYPERLINK

   if the link hostname is not set, it will return an error message
   if the relative url is not set, it will return an error message
   if the link text is not set, it will return an error message
*/
DROP FUNCTION IF EXISTS bc_excel_link;

CREATE FUNCTION bc_excel_link(relative_url TEXT, link_text TEXT)
RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE link_hostname TEXT;
    DECLARE full_url TEXT;

    -- Get the link hostname from the settings table
    SELECT value INTO link_hostname FROM settings WHERE `option` = 'report-link-hostname-override';

    -- Handle the case where the link hostname is not set
    IF COALESCE(TRIM(link_hostname), '') = '' THEN
        RETURN 'Please define global.report-link-hostname-override under Advanced Settings';
    END IF;

    -- Handle the case where the relative url is not set
    IF COALESCE(TRIM(relative_url), '') = '' THEN
        RETURN 'Please provide the relative url for the link as the first parameter';
    END IF;

    -- Handle the case where the link text is not set
    IF COALESCE(TRIM(link_text), '') = '' THEN
        RETURN 'Please provide the link text for the link as the second parameter';
    END IF;

    -- If link_hostname does not end with a single /, add it
    IF RIGHT(link_hostname, 1) != '/' THEN
        SET link_hostname = CONCAT(link_hostname, '/');
    END IF;

    -- If relative_url starts with a /, remove it
    IF LEFT(relative_url, 1) = '/' THEN
        SET relative_url = SUBSTRING(relative_url, 2);
    END IF;

    SET full_url = CONCAT(link_hostname, relative_url);

    -- Return the Excel formula
    RETURN CONCAT('=HYPERLINK("', full_url, '", "', link_text, '")');
END;
