use mydb;

-- Obter o total de paises
drop procedure if exists count_countries;
DELIMITER //
create procedure count_countries()
begin
	select count(country_code) from Country;
end //
DELIMITER ;

call count_countries;


-- Calcular os casos totais num pais
drop procedure if exists count_country_total;
DELIMITER //
create procedure count_country_total(in country varchar(45))
begin
	select sum(cases) from Day where country_code = country;
end //
DELIMITER ;

call count_country_total('AT');

-- Calcular as mortes totais num pais
drop procedure if exists count_country_total_deaths;
DELIMITER //
create procedure count_country_total_deaths(in country varchar(45))
begin
	select sum(deaths) from Day where country_code = country;
end //
DELIMITER ;

call count_country_total_deaths('AT');


-- Percentagem de infetados
DELIMITER $$
CREATE FUNCTION infected_percentage (population int, cases int) 
RETURNS decimal
DETERMINISTIC
BEGIN 
  DECLARE percentage decimal;
  SET percentage = cases / population * 100;
  RETURN percentage;
END$$
DELIMITER ;

-- Atualiza os casos semanais sempre que é adicionada uma nova info diária
drop trigger if exists update_cases;
DELIMITER //
create trigger update_cases
after insert on Day
for each row
begin

update Week
set cases = cases + new.cases
where week = new.week;

end;
//
DELIMITER ;

