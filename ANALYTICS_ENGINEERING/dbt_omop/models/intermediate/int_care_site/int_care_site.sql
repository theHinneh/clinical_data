select * from {{ref('int_org_care_site')}}
union
select * from {{ref('int_provider_care_site')}}