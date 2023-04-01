$headers = @{
'Accept'='application/json; charset=utf-8'
'Content-Type'='application/json; charset=utf-8'
'Authorization'='OAuth #####ReplaceThisStringWithKeyFromStep4.3#####'
}
$headers

$orgid = (Invoke-RestMethod -Method Get -Uri "https://api360.yandex.net/directory/v1/org" -Headers $headers -ContentType 'application/json; charset=utf-8').organizations[0].id
$orgid

(([Text.Encoding]::UTF8.GetString((curl "https://api360.yandex.net/directory/v1/org/$orgid/users?per_page=999" -Headers $headers -ContentType 'application/json; charset=utf-8').RawContentStream.ToArray())  -join "")|ConvertFrom-Json).users | select-object @{Name="FirstName";Expression={$_.name.first}},@{Name="MiddleName";Expression={$_.name.middle}},@{Name="LastName";Expression={$_.name.last}},@{Name="id";Expression={$_.id}},@{Name="Email";Expression={$_.email}},@{Name="position";Expression={$_.position}},@{Name="gender";Expression={$_.gender}},@{Name="departmentId";Expression={$_.departmentId}},@{Name="about";Expression={$_.about}},@{Name="isEnabled";Expression={$_.isEnabled}},@{Name="birthday";Expression={$_.birthday}}  | Export-Csv -Path ./users.csv -NoTypeInformation -Encoding UTF8

(([Text.Encoding]::UTF8.GetString((curl "https://api360.yandex.net/directory/v1/org/$orgid/departments?per_page=999" -Headers $headers -ContentType 'application/json; charset=utf-8').RawContentStream.ToArray())  -join "")|ConvertFrom-Json).departments | Export-Csv -Path ./deps.csv -NoTypeInformation -Encoding UTF8

(([Text.Encoding]::UTF8.GetString((curl "https://api360.yandex.net/directory/v1/org/$orgid/groups?per_page=999" -Headers $headers -ContentType 'application/json; charset=utf-8').RawContentStream.ToArray())  -join "")|ConvertFrom-Json).groups | Export-Csv -Path ./groups.csv -NoTypeInformation -Encoding UTF8