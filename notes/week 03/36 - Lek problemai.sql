--36 Össesítő lekérdezések problémái
--Soroljuk fel milyen városnevek vannak egy , vel elválasztott listában.
--STRING_AGG
--STRING_AGG aggregation result exceeded the limit of 8000 bytes. Use LOB types to avoid result truncation.

SELECT Country, STRING_AGG(Cast(City as nvarchar(max)),', ') --mező típusának megváltoztatása a fenti hiba miatt
FROM Customer
GROUP BY Country