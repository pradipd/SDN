cmd /c """netsh trace start globallevel=6 provider={564368D6-577B-4af5-AD84-1C54464848E6} provider={0c885e0d-6eb6-476c-a048-2457eed3a5c1} provider={80CE50DE-D264-4581-950D-ABADEEE0D340} provider={D0E4BC17-34C7-43fc-9A72-D89A59D6979A} provider={93f693dc-9163-4dee-af64-d855218af242} provider={A6F32731-9A38-4159-A220-3D9B7FC5FE5D} report=di capture=no tracefile=c:\server.etl maxSize=1024 overwrite=yes persistent=yes"""

while ($true) {
    [array]$policies = Get-HnsPolicyList
    if ($policies) {
        foreach ($policy in $policies) {
            write-host "**********************"
            write-host "Policy: $($policy.ID)"
            $pjson = $policy | ConvertTo-Json -Depth 10
            write-host $pjson
            $endpoints = (Get-HnsPolicyList -Id $policy.ID).References
            write-host "Endpoints: $endpoints"
            foreach($endpoint in $endpoints) {
                write-host "EndpointID: $endpoint"
                $epID = $endpoint.Replace("/endpoints/", "")
                $hnsEndpoint = Get-HnsEndpoint -Id $epID
                if ($hnsEndpoint) {
                    $ejson = $hnsEndpoint | ConvertTo-Json -Depth 10
                    write-host $ejson            
                } else {
                    #Stop trace
                    netsh trace stop
                    exit(-1)
                }
            }
        }
    }
    Start-Sleep -Seconds 5
}