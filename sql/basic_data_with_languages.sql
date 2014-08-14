/* get english data */
select
j.position, j.provided_by, j.deadline, j.location, j.job_type, 
j.salary, j.salary_start, j.salary_end,
j.qualifications_degree,j.qualifications_work_experience,
lang_count.count as num_langs_required,
kl_eng.writing as 'english writing', kl_eng.reading as 'english reading',
kl_geo.writing as 'georgian writing', kl_geo.reading as 'georgian reading',
kl_rus.writing as 'russian writing', kl_rus.reading as 'russian reading',
kl_ger.writing as 'german writing', kl_ger.reading as 'german reading',
kl_fr.writing as 'french writing', kl_fr.reading as 'french reading',
kl_arm.writing as 'armenian writing', kl_arm.reading as 'armenian reading',
kl_oct.writing as 'occitian writing', kl_oct.reading as 'occitian reading'
from
  jobs as j
  left join (
   select jobs_id, count(*) as count from knowledge_languages group by jobs_id
  ) as lang_count on lang_count.jobs_id = j.id
  left join knowledge_languages as kl_eng on kl_eng.jobs_id = j.id and kl_eng.language = 'English'
  left join knowledge_languages as kl_geo on kl_geo.jobs_id = j.id and kl_geo.language = 'Georgian'
  left join knowledge_languages as kl_rus on kl_rus.jobs_id = j.id and kl_rus.language = 'Russian'
  left join knowledge_languages as kl_ger on kl_ger.jobs_id = j.id and kl_ger.language = 'German'
  left join knowledge_languages as kl_fr on kl_fr.jobs_id = j.id and kl_fr.language = 'French'
  left join knowledge_languages as kl_arm on kl_arm.jobs_id = j.id and kl_arm.language = 'Armenian'
  left join knowledge_languages as kl_oct on kl_oct.jobs_id = j.id and kl_oct.language = 'Occitan'
where j.locale = 'eng'

/* get georgian data */

select
j.id, j.position, j.provided_by, j.deadline, j.location, j.job_type, 
j.salary, j.salary_start, j.salary_end,
j.qualifications_degree,j.qualifications_work_experience,
lang_count.count as num_langs_required,
kl_eng.writing as 'english writing', kl_eng.reading as 'english reading',
kl_geo.writing as 'georgian writing', kl_geo.reading as 'georgian reading',
kl_rus.writing as 'russian writing', kl_rus.reading as 'russian reading',
kl_ger.writing as 'german writing', kl_ger.reading as 'german reading',
kl_fr.writing as 'french writing', kl_fr.reading as 'french reading',
kl_arm.writing as 'armenian writing', kl_arm.reading as 'armenian reading',
kl_oct.writing as 'occitian writing', kl_oct.reading as 'occitian reading'
from
  jobs as j
  left join (
   select jobs_id, count(*) as count from knowledge_languages group by jobs_id
  ) as lang_count on lang_count.jobs_id = j.id
  left join knowledge_languages as kl_eng on kl_eng.jobs_id = j.id and kl_eng.language = 'ინგლისური'
  left join knowledge_languages as kl_geo on kl_geo.jobs_id = j.id and kl_geo.language = 'ქართული'
  left join knowledge_languages as kl_rus on kl_rus.jobs_id = j.id and kl_rus.language = 'რუსული'
  left join knowledge_languages as kl_ger on kl_ger.jobs_id = j.id and kl_ger.language = 'German'
  left join knowledge_languages as kl_fr on kl_fr.jobs_id = j.id and kl_fr.language = 'French'
  left join knowledge_languages as kl_arm on kl_arm.jobs_id = j.id and kl_arm.language = 'სომხური'
  left join knowledge_languages as kl_oct on kl_oct.jobs_id = j.id and kl_oct.language = 'Occitan'
where j.locale = 'geo';

