{{- define "main" }}
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trivy Security Report</title>

<style>
body {
  font-family: "Segoe UI", Arial;
  background: #f5f7fa;
  margin: 0;
}

.header {
  background: #1f2937;
  color: white;
  padding: 20px;
}

.container {
  padding: 20px;
}

.card {
  background: white;
  border-radius: 10px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.08);
}

h2 { margin-top: 0; }

table {
  width: 100%;
  border-collapse: collapse;
}

th {
  background: #111827;
  color: white;
  padding: 10px;
}

td {
  padding: 8px;
  border-bottom: 1px solid #ddd;
}

.CRITICAL { color: #dc2626; font-weight: bold; }
.HIGH { color: #ea580c; font-weight: bold; }
.MEDIUM { color: #ca8a04; }
.LOW { color: #16a34a; }

.summary span {
  margin-right: 20px;
  font-weight: bold;
}
</style>

</head>

<body>

<div class="header">
  <h1>🔐 Trivy Security Report</h1>
</div>

<div class="container">

{{ range .Results }}
<div class="card">

<h2>📦 {{ .Target }}</h2>

<div class="summary">
  <span class="CRITICAL">Critical: {{ len (where .Vulnerabilities "Severity" "CRITICAL") }}</span>
  <span class="HIGH">High: {{ len (where .Vulnerabilities "Severity" "HIGH") }}</span>
  <span class="MEDIUM">Medium: {{ len (where .Vulnerabilities "Severity" "MEDIUM") }}</span>
  <span class="LOW">Low: {{ len (where .Vulnerabilities "Severity" "LOW") }}</span>
</div>

<br>

<table>
<tr>
<th>Package</th>
<th>Severity</th>
<th>CVE</th>
<th>Installed</th>
<th>Fixed</th>
</tr>

{{ range .Vulnerabilities }}
<tr>
<td>{{ .PkgName }}</td>
<td class="{{ .Severity }}">{{ .Severity }}</td>
<td>{{ .VulnerabilityID }}</td>
<td>{{ .InstalledVersion }}</td>
<td>{{ .FixedVersion }}</td>
</tr>
{{ end }}

</table>

</div>
{{ end }}

</div>
</body>
</html>
{{- end }}
