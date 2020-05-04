insert INTO deploy_mgt(web_hostname, was_hostname, service)
SELECT 
	  web.hostname
	 ,was.hostname
	 ,was.service
from 
	 host_info web
	,host_info was
where  web.host_id = was.parent_id
and web.type ='web'
--and web.hostname = 'shop2web175'
and web.use_yn ='Y'
and was.type = 'was'
--and was.hostname = 'shop2was29'
and was.use_yn ='Y'
order by web.hostname, was.hostname

