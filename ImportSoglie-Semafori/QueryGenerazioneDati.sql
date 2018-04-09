select p.SNDG + ';' +
CASE
Cast(RAND()*(4-1)+1 as int)
 WHEN 1 THEN 'R'
 WHEN 2 THEN 'G'
 WHEN 3 THEN 'V'
 WHEN 4 THEN 'R'
END  + ';' +
CONVERT(VARCHAR,Cast(RAND()*1+0 as int) )  + ';' +
Cast(RAND()*120000 as varchar)
from
SK_F2.F2_T_Persona p,
SK_F2.F2_T_Persona_Giuridica pg
where p.ID = pg.ID_Persona
and p.ID between 1 and 1500
and p.SNDG is not null

select p.SNDG + ';' +
CASE
Cast(RAND()*(4-1)+1 as int)
 WHEN 1 THEN 'R'
 WHEN 2 THEN 'G'
 WHEN 3 THEN 'V'
 WHEN 4 THEN 'R'
END  + ';' +
Cast(RAND()*1+0 as varchar)  + ';' +
Cast(RAND()*120000 as varchar)
from
SK_F2.F2_T_Persona p,
SK_F2.F2_T_Persona_Giuridica pg
where p.ID = pg.ID_Persona
and p.ID between 1501 and 2500
and p.SNDG is not null

select p.SNDG + ';' +
CASE
Cast(RAND()*(4-1)+1 as int)
 WHEN 1 THEN 'R'
 WHEN 2 THEN 'G'
 WHEN 3 THEN 'V'
 WHEN 4 THEN 'R'
END  + ';' +
Cast(RAND()*1+0 as varchar)  + ';' +
Cast(RAND()*120000 as varchar)
from
SK_F2.F2_T_Persona p,
SK_F2.F2_T_Persona_Giuridica pg
where p.ID = pg.ID_Persona
and p.ID between 2501 and 3000
and p.SNDG is not null

select p.SNDG + ';' +
CASE
Cast(RAND()*(4-1)+1 as int)
 WHEN 1 THEN 'R'
 WHEN 2 THEN 'G'
 WHEN 3 THEN 'V'
 WHEN 4 THEN 'R'
END  + ';' +
CONVERT(VARCHAR,Cast(RAND()*1+0 as int) )  + ';' +
Cast(RAND()*120000 as varchar)
from
SK_F2.F2_T_Persona p,
SK_F2.F2_T_Persona_Giuridica pg
where p.ID = pg.ID_Persona
and p.ID > 3000
and p.SNDG is not null