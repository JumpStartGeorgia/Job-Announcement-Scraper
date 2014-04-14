/* add start/end salary fields and populate them */
ALTER TABLE `jobs`
	ADD COLUMN `salary_start` SMALLINT NULL DEFAULT NULL AFTER `salary`,
	ADD COLUMN `salary_end` SMALLINT NULL DEFAULT NULL AFTER `salary_start`,
	ADD INDEX `Index 5` (`salary_start`),
	ADD INDEX `Index 6` (`salary_end`);

/* update english records */
update jobs as j
  inner join (
  	select id,
	  trim(replace(replace(replace(replace(replace(salary, ' GEL', ''), 'From ', ''), 'To ', ''), ' - ', '-'), '- ', '-')) as salary
  	from jobs
  ) as js on js.id = j.id
set
salary_start = if (js.salary not regexp '[0-9]', null, 
	if(instr(js.salary, '-') = 0, js.salary, 
	  if(instr(js.salary, '-') = 1, right(js.salary, length(js.salary)-1), 
		  mid(js.salary, 1, instr(js.salary, '-')-1))
	)
),
salary_end = if (js.salary not regexp '[0-9]', null, 
	if(instr(js.salary, '-') = 0, js.salary, 
	  if(instr(js.salary, '-') = 1, right(js.salary, length(js.salary)-1), 
		  mid(js.salary, instr(js.salary, '-')+1))
	) 
)
where j.locale = 'eng';

/* update geo records */
update jobs as j
  inner join (
  	select id,
    trim(replace(replace(replace(replace(replace(replace(salary, ' ლარი', ''), ' ლარიდან', ''), ' ლარამდე', ''), 'დან', ''), ' - ', '-'), '- ', '-')) as salary
	  from jobs
  ) as js on js.id = j.id

set
salary_start = if (js.salary not regexp '[0-9]', null, 
	if(instr(js.salary, '-') = 0, js.salary, 
	  if(instr(js.salary, '-') = 1, right(js.salary, length(js.salary)-1), 
		  mid(js.salary, 1, instr(js.salary, '-')-1))
	)
),
salary_end = if (js.salary not regexp '[0-9]', null, 
	if(instr(js.salary, '-') = 0, js.salary, 
	  if(instr(js.salary, '-') = 1, right(js.salary, length(js.salary)-1), 
		  mid(js.salary, instr(js.salary, '-')+1))
	)
)
where j.locale = 'geo';
  


