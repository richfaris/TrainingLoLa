/* v_counties - simple complete counties view */
create or replace algorithm = merge view v_counties as
select
    c.id as county_id,
    c.name as county_name,
    c.code as county_code,
    co.id as country_id,
    co.name as country_name,
    co.abbreviation as country_abbreviation,
    bl.id as state_id,
    bl.name as state_name,
    bl.abbreviation as state_abbreviation
from business_locations bl
JOIN json_table(
    bl.counties,
    '$[*]' COLUMNS (
        id   VARCHAR(64) PATH '$.id',
        name VARCHAR(255) PATH '$.name',
        code VARCHAR(255) PATH '$.code',
        active TINYINT(1) PATH '$.checked'
    )
) as c on TRUE
join countries co on co.id = bl.countryId
where bl.checked = 1 and c.active = 1
;