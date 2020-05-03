SELECT 
	CASE t.number 
		WHEN 1 
			THEN 'mkdir -p {conf_path}' || server.path
			ELSE 'touch {conf_path}' || server.path || '/' || server.service || '.conf'
		END cmd
FROM copy_t t,
(
	SELECT 
		 web.hostname || '/' || was.hostname path 
		 , port.service service
	from 
		 host_info web
		,host_info was
		,(  
			select 
				service 
			from port_info
			where use_yn = 'Y'
			group by service
		) port
	where web.host_id = was.parent_id
	and was.service = port.service
	and web.type='web'
	and web.use_yn='Y'
	and was.type = 'was'
	and was.use_yn='Y'
) server
union all
SELECT 
	 'echo "server ' || was.host || ':' || port.port || ';" >> {conf_path}'|| web.hostname || '/' || was.hostname || '/' || port.service || '.conf' cmd
from 
	host_info web
	, host_info was
	,port_info port
where  web.host_id = was.parent_id
and was.service = port.service
and web.type ='web'
and web.use_yn ='Y'
and was.type = 'was'
and was.use_yn ='Y'
and port.use_yn = 'Y'

