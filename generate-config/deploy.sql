select 
	 web_hostname
	,min(was_hostname) was_hostname
	,min(services) services
from
(
	SELECT
		 web_hostname
		,was_hostname
		,group_concat(service) services
	from deploy_mgt
	WHERE health_check_yn = 'N'
	and deploy_tp = 'N'
	group by web_hostname,was_hostname
)
group by web_hostname
