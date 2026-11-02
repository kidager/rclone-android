Licenses of the Go modules built into librclone.so
{{ range . }}
================================================================================
{{ .Name }} {{ .Version }} ({{ .LicenseName }})
{{ .LicenseURL }}

{{ .LicenseText }}
{{ end }}
