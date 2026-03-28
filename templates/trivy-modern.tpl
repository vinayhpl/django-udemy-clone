<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🔒 Trivy Security Scan Report - {{ .Target }}</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
            background: #f0f2f5;
            padding: 20px;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
        }
        
        /* Header */
        .header {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .header h1 {
            font-size: 2em;
            margin-bottom: 10px;
        }
        
        .badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            background: rgba(255,255,255,0.2);
            margin-top: 10px;
        }
        
        /* Summary Cards */
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            transition: transform 0.2s;
        }
        
        .card:hover { transform: translateY(-5px); }
        
        .card h3 { font-size: 0.9em; color: #666; margin-bottom: 10px; text-transform: uppercase; }
        .card .count { font-size: 2.5em; font-weight: bold; margin: 10px 0; }
        .card.critical .count { color: #dc3545; }
        .card.high .count { color: #fd7e14; }
        .card.medium .count { color: #ffc107; }
        .card.low .count { color: #28a745; }
        .card.total .count { color: #6c757d; }
        
        /* Charts Section */
        .charts-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .chart-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        
        .chart-card h3 {
            margin-bottom: 15px;
            color: #333;
        }
        
        canvas { max-height: 300px; }
        
        /* Vulnerabilities Table */
        .vuln-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        
        .vuln-table h3 {
            padding: 20px;
            background: #f8f9fa;
            border-bottom: 2px solid #e9ecef;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            background: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
        }
        
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #e9ecef;
        }
        
        tr:hover { background: #f8f9fa; }
        
        .severity {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: bold;
        }
        
        .severity.CRITICAL { background: #dc3545; color: white; }
        .severity.HIGH { background: #fd7e14; color: white; }
        .severity.MEDIUM { background: #ffc107; color: #333; }
        .severity.LOW { background: #28a745; color: white; }
        
        .cve-link {
            color: #007bff;
            text-decoration: none;
        }
        
        .cve-link:hover { text-decoration: underline; }
        
        @media (max-width: 768px) {
            .charts-section { grid-template-columns: 1fr; }
            .summary-grid { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔒 Trivy Security Scan Report</h1>
            <div><strong>Target:</strong> {{ .Target }}</div>
            <div class="badge">📅 Generated: {{ now | date "2006-01-02 15:04:05" }}</div>
        </div>
        
        {{ $total := len .Vulnerabilities }}
        {{ $critical := 0 }}{{ $high := 0 }}{{ $medium := 0 }}{{ $low := 0 }}
        {{ range .Vulnerabilities }}
            {{ if eq .Severity "CRITICAL" }}{{ $critical = add $critical 1 }}{{ end }}
            {{ if eq .Severity "HIGH" }}{{ $high = add $high 1 }}{{ end }}
            {{ if eq .Severity "MEDIUM" }}{{ $medium = add $medium 1 }}{{ end }}
            {{ if eq .Severity "LOW" }}{{ $low = add $low 1 }}{{ end }}
        {{ end }}
        
        <div class="summary-grid">
            <div class="card total"><h3>Total Vulnerabilities</h3><div class="count">{{ $total }}</div></div>
            <div class="card critical"><h3>Critical</h3><div class="count">{{ $critical }}</div></div>
            <div class="card high"><h3>High</h3><div class="count">{{ $high }}</div></div>
            <div class="card medium"><h3>Medium</h3><div class="count">{{ $medium }}</div></div>
            <div class="card low"><h3>Low</h3><div class="count">{{ $low }}</div></div>
        </div>
        
        <div class="charts-section">
            <div class="chart-card">
                <h3>📊 Severity Distribution</h3>
                <canvas id="severityChart"></canvas>
            </div>
            <div class="chart-card">
                <h3>🎯 Risk Overview</h3>
                <canvas id="riskChart"></canvas>
            </div>
        </div>
        
        <div class="vuln-table">
            <h3>📋 Detailed Vulnerability List</h3>
            <table>
                <thead>
                    <tr><th>Package</th><th>Vulnerability ID</th><th>Severity</th><th>Installed Version</th><th>Fixed Version</th></tr>
                </thead>
                <tbody>
                    {{ range .Vulnerabilities }}
                    <tr>
                        <td>{{ .PkgName }}</td>
                        <td><a href="https://nvd.nist.gov/vuln/detail/{{ .VulnerabilityID }}" target="_blank" class="cve-link">{{ .VulnerabilityID }}</a></td>
                        <td><span class="severity {{ .Severity }}">{{ .Severity }}</span></td>
                        <td>{{ .InstalledVersion }}</td>
                        <td>{{ if .FixedVersion }}{{ .FixedVersion }}{{ else }}-{{ end }}</td>
                    </tr>
                    {{ end }}
                </tbody>
            </table>
        </div>
    </div>
    
    <script>
        const ctx1 = document.getElementById('severityChart').getContext('2d');
        new Chart(ctx1, {
            type: 'doughnut',
            data: {
                labels: ['Critical ({{ $critical }})', 'High ({{ $high }})', 'Medium ({{ $medium }})', 'Low ({{ $low }})'],
                datasets: [{
                    data: [{{ $critical }}, {{ $high }}, {{ $medium }}, {{ $low }}],
                    backgroundColor: ['#dc3545', '#fd7e14', '#ffc107', '#28a745'],
                    borderWidth: 0
                }]
            },
            options: { responsive: true, plugins: { legend: { position: 'bottom' } } }
        });
        
        const ctx2 = document.getElementById('riskChart').getContext('2d');
        new Chart(ctx2, {
            type: 'bar',
            data: {
                labels: ['Critical', 'High', 'Medium', 'Low'],
                datasets: [{
                    label: 'Number of Vulnerabilities',
                    data: [{{ $critical }}, {{ $high }}, {{ $medium }}, {{ $low }}],
                    backgroundColor: ['#dc3545', '#fd7e14', '#ffc107', '#28a745'],
                    borderRadius: 8
                }]
            },
            options: { responsive: true, plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } } }
        });
    </script>
</body>
</html>
