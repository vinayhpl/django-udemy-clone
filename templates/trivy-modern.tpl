<!DOCTYPE html>
<html lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{- escapeXML ( index . 0 ).Target }} - Trivy Security Report - {{ now }}</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      padding: 2rem;
      line-height: 1.6;
    }

    .container {
      max-width: 1400px;
      margin: 0 auto;
      background: white;
      border-radius: 20px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.3);
      overflow: hidden;
    }

    /* Header Section */
    .header {
      background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
      color: white;
      padding: 2rem;
      text-align: center;
    }

    .header h1 {
      font-size: 2.5rem;
      margin-bottom: 0.5rem;
      font-weight: 700;
    }

    .header .target {
      font-size: 1.2rem;
      opacity: 0.9;
      font-family: monospace;
      background: rgba(255,255,255,0.1);
      display: inline-block;
      padding: 0.5rem 1rem;
      border-radius: 8px;
      margin-top: 0.5rem;
    }

    .header .timestamp {
      font-size: 0.9rem;
      opacity: 0.8;
      margin-top: 1rem;
    }

    /* Stats Cards */
    .stats {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 1rem;
      padding: 2rem;
      background: #f8f9fa;
      border-bottom: 1px solid #e9ecef;
    }

    .stat-card {
      background: white;
      padding: 1.5rem;
      border-radius: 12px;
      text-align: center;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      transition: transform 0.2s, box-shadow 0.2s;
    }

    .stat-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    .stat-number {
      font-size: 2rem;
      font-weight: bold;
      margin-bottom: 0.5rem;
    }

    .stat-label {
      color: #6c757d;
      font-size: 0.9rem;
      text-transform: uppercase;
      letter-spacing: 1px;
    }

    .stat-critical { color: #dc3545; }
    .stat-high { color: #fd7e14; }
    .stat-medium { color: #ffc107; }
    .stat-low { color: #28a745; }

    /* Section Styles */
    .section {
      margin: 2rem;
      background: white;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .section-header {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      padding: 1rem 1.5rem;
      border-bottom: 3px solid #667eea;
    }

    .section-header h2 {
      color: #1e3c72;
      font-size: 1.5rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .section-header h2::before {
      content: "🔍";
      font-size: 1.3rem;
    }

    /* Table Styles */
    .table-wrapper {
      overflow-x: auto;
      padding: 1rem;
    }

    table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
      font-size: 0.9rem;
    }

    th {
      background: #f8f9fa;
      padding: 1rem;
      text-align: left;
      font-weight: 600;
      color: #495057;
      border-bottom: 2px solid #dee2e6;
      position: sticky;
      top: 0;
      background: white;
    }

    td {
      padding: 1rem;
      border-bottom: 1px solid #e9ecef;
      vertical-align: top;
    }

    tr:hover {
      background-color: #f8f9fa;
      transition: background-color 0.2s;
    }

    /* Severity Styles */
    .severity-badge {
      display: inline-block;
      padding: 0.25rem 0.75rem;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .severity-CRITICAL .severity-badge { background: #dc3545; color: white; }
    .severity-HIGH .severity-badge { background: #fd7e14; color: white; }
    .severity-MEDIUM .severity-badge { background: #ffc107; color: #212529; }
    .severity-LOW .severity-badge { background: #28a745; color: white; }
    .severity-UNKNOWN .severity-badge { background: #6c757d; color: white; }

    tr.severity-CRITICAL { background: rgba(220, 53, 69, 0.05); border-left: 4px solid #dc3545; }
    tr.severity-HIGH { background: rgba(253, 126, 20, 0.05); border-left: 4px solid #fd7e14; }
    tr.severity-MEDIUM { background: rgba(255, 193, 7, 0.05); border-left: 4px solid #ffc107; }
    tr.severity-LOW { background: rgba(40, 167, 69, 0.05); border-left: 4px solid #28a745; }
    tr.severity-UNKNOWN { background: rgba(108, 117, 125, 0.05); border-left: 4px solid #6c757d; }

    /* Package and Version Styles */
    .pkg-name {
      font-family: 'Courier New', monospace;
      font-weight: 600;
      color: #495057;
    }

    .pkg-version {
      font-family: monospace;
      font-size: 0.85rem;
    }

    .fixed-version {
      color: #28a745;
      font-weight: 600;
    }

    /* Links Section */
    .links {
      display: flex;
      flex-wrap: wrap;
      gap: 0.5rem;
    }

    .links a {
      display: inline-block;
      padding: 0.25rem 0.75rem;
      background: #f8f9fa;
      color: #007bff;
      text-decoration: none;
      border-radius: 4px;
      font-size: 0.8rem;
      transition: all 0.2s;
    }

    .links a:hover {
      background: #007bff;
      color: white;
      transform: translateY(-1px);
    }

    .toggle-more-links {
      cursor: pointer;
      background: #e9ecef !important;
      color: #495057 !important;
    }

    .toggle-more-links:hover {
      background: #dee2e6 !important;
      color: #212529 !important;
    }

    /* Misconfiguration Styles */
    .misconf-message {
      background: #f8f9fa;
      padding: 0.75rem;
      border-radius: 6px;
      margin-bottom: 0.5rem;
      font-size: 0.85rem;
      line-height: 1.5;
    }

    .misconf-link {
      display: inline-block;
      margin-top: 0.5rem;
      color: #007bff;
      text-decoration: none;
    }

    .misconf-link:hover {
      text-decoration: underline;
    }

    /* Empty State */
    .empty-state {
      text-align: center;
      padding: 3rem;
      color: #6c757d;
    }

    .empty-state svg {
      width: 80px;
      height: 80px;
      margin-bottom: 1rem;
      opacity: 0.5;
    }

    /* Footer */
    .footer {
      background: #f8f9fa;
      padding: 1.5rem;
      text-align: center;
      color: #6c757d;
      font-size: 0.85rem;
      border-top: 1px solid #e9ecef;
    }

    /* Responsive */
    @media (max-width: 768px) {
      body {
        padding: 1rem;
      }
      
      .section {
        margin: 1rem;
      }
      
      .stats {
        grid-template-columns: repeat(2, 1fr);
        padding: 1rem;
      }
      
      th, td {
        padding: 0.75rem;
      }
      
      .header h1 {
        font-size: 1.5rem;
      }
    }

    /* Print Styles */
    @media print {
      body {
        background: white;
        padding: 0;
      }
      
      .stats, .footer {
        background: #f8f9fa;
      }
      
      tr:hover {
        background-color: transparent;
      }
      
      .links a {
        background: #f8f9fa;
        border: 1px solid #dee2e6;
      }
    }
  </style>
  <script>
    window.onload = function() {
      // Handle toggle more links
      document.querySelectorAll('td.links').forEach(function(linkCell) {
        var links = Array.from(linkCell.querySelectorAll('a:not(.toggle-more-links)'));
        if (links.length > 3) {
          links.sort(function(a, b) {
            return a.href > b.href ? 1 : -1;
          });
          // Clear existing links
          linkCell.innerHTML = '';
          // Add first 3 links
          links.slice(0, 3).forEach(function(link) {
            linkCell.appendChild(link);
          });
          // Add toggle button
          var toggleLink = document.createElement('a');
          toggleLink.innerText = `Show ${links.length - 3} more links`;
          toggleLink.href = "#";
          toggleLink.className = "toggle-more-links";
          toggleLink.onclick = function(e) {
            e.preventDefault();
            var expanded = linkCell.getAttribute("data-more-links");
            if (expanded === "on") {
              // Hide extra links
              while (linkCell.children.length > 4) {
                linkCell.removeChild(linkCell.lastChild);
              }
              linkCell.setAttribute("data-more-links", "off");
              toggleLink.innerText = `Show ${links.length - 3} more links`;
            } else {
              // Show all links
              links.slice(3).forEach(function(link) {
                linkCell.appendChild(link);
              });
              linkCell.setAttribute("data-more-links", "on");
              toggleLink.innerText = "Show less";
            }
            return false;
          };
          linkCell.appendChild(toggleLink);
          linkCell.setAttribute("data-more-links", "off");
        }
      });
    };
  </script>
</head>
<body>
  <div class="container">
    {{- if . }}
    <!-- Header -->
    <div class="header">
      <h1>🔒 Trivy Security Report</h1>
      <div class="target">{{- escapeXML ( index . 0 ).Target }}</div>
      <div class="timestamp">Generated: {{ now }}</div>
    </div>

    <!-- Stats Section -->
    {{- $totalVulns := 0 }}
    {{- $criticalCount := 0 }}
    {{- $highCount := 0 }}
    {{- $mediumCount := 0 }}
    {{- $lowCount := 0 }}
    {{- range . }}
      {{- range .Vulnerabilities }}
        {{- $totalVulns = add $totalVulns 1 }}
        {{- if eq .Vulnerability.Severity "CRITICAL" }}{{ $criticalCount = add $criticalCount 1 }}{{ end }}
        {{- if eq .Vulnerability.Severity "HIGH" }}{{ $highCount = add $highCount 1 }}{{ end }}
        {{- if eq .Vulnerability.Severity "MEDIUM" }}{{ $mediumCount = add $mediumCount 1 }}{{ end }}
        {{- if eq .Vulnerability.Severity "LOW" }}{{ $lowCount = add $lowCount 1 }}{{ end }}
      {{- end }}
    {{- end }}
    
    <div class="stats">
      <div class="stat-card">
        <div class="stat-number">{{ $totalVulns }}</div>
        <div class="stat-label">Total Vulnerabilities</div>
      </div>
      <div class="stat-card">
        <div class="stat-number stat-critical">{{ $criticalCount }}</div>
        <div class="stat-label">Critical</div>
      </div>
      <div class="stat-card">
        <div class="stat-number stat-high">{{ $highCount }}</div>
        <div class="stat-label">High</div>
      </div>
      <div class="stat-card">
        <div class="stat-number stat-medium">{{ $mediumCount }}</div>
        <div class="stat-label">Medium</div>
      </div>
      <div class="stat-card">
        <div class="stat-number stat-low">{{ $lowCount }}</div>
        <div class="stat-label">Low</div>
      </div>
    </div>

    {{- range . }}
    <!-- Vulnerabilities Section -->
    <div class="section">
      <div class="section-header">
        <h2>📦 {{ .Type | toString | escapeXML }}</h2>
      </div>
      {{- if (eq (len .Vulnerabilities) 0) }}
      <div class="empty-state">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M20 12V8H6a2 2 0 0 1-2-2c0-1.1.9-2 2-2h12v4M4 6v12a2 2 0 0 0 2 2h14V8"/>
          <path d="M18 2v4M6 2v4"/>
        </svg>
        <p>✅ No vulnerabilities found</p>
      </div>
      {{- else }}
      <div class="table-wrapper">
        <table>
          <thead>
            <tr>
              <th>📦 Package</th>
              <th>🆔 Vulnerability ID</th>
              <th>⚠️ Severity</th>
              <th>📌 Installed Version</th>
              <th>🔧 Fixed Version</th>
              <th>🔗 References</th>
            </tr>
          </thead>
          <tbody>
            {{- range .Vulnerabilities }}
            <tr class="severity-{{ escapeXML .Vulnerability.Severity }}">
              <td class="pkg-name">{{ escapeXML .PkgName }}</td>
              <td><code>{{ escapeXML .VulnerabilityID }}</code></td>
              <td><span class="severity-badge">{{ escapeXML .Vulnerability.Severity }}</span></td>
              <td class="pkg-version">{{ escapeXML .InstalledVersion }}</td>
              <td class="fixed-version">{{ if .FixedVersion }}{{ escapeXML .FixedVersion }}{{ else }}-{{ end }}</td>
              <td class="links" data-more-links="off">
                {{- range .Vulnerability.References }}
                <a href="{{ escapeXML . | printf "%q" }}" target="_blank" rel="noopener noreferrer">{{ escapeXML . | truncate 50 }}</a>
                {{- end }}
              </td>
            </tr>
            {{- end }}
          </tbody>
        </table>
      </div>
      {{- end }}
    </div>

    <!-- Misconfigurations Section -->
    <div class="section">
      <div class="section-header">
        <h2>⚙️ Misconfigurations - {{ .Type | toString | escapeXML }}</h2>
      </div>
      {{- if (eq (len .Misconfigurations) 0) }}
      <div class="empty-state">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M12 8v4m0 4h.01M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20z"/>
        </svg>
        <p>✅ No misconfigurations found</p>
      </div>
      {{- else }}
      <div class="table-wrapper">
        <table>
          <thead>
            <tr>
              <th>🏷️ Type</th>
              <th>🆔 ID</th>
              <th>📋 Check</th>
              <th>⚠️ Severity</th>
              <th>💬 Message & Resources</th>
            </tr>
          </thead>
          <tbody>
            {{- range .Misconfigurations }}
            <tr class="severity-{{ escapeXML .Severity }}">
              <td><code>{{ escapeXML .Type }}</code></td>
              <td><code>{{ escapeXML .ID }}</code></td>
              <td><strong>{{ escapeXML .Title }}</strong></td>
              <td><span class="severity-badge">{{ escapeXML .Severity }}</span></td>
              <td>
                <div class="misconf-message">{{ escapeXML .Message }}</div>
                {{- if .PrimaryURL }}
                <a href="{{ escapeXML .PrimaryURL | printf "%q" }}" class="misconf-link" target="_blank" rel="noopener noreferrer">
                  📖 View Documentation →
                </a>
                {{- end }}
              </td>
            </tr>
            {{- end }}
          </tbody>
        </table>
      </div>
      {{- end }}
    </div>
    {{- end }}

    {{- else }}
    <!-- Empty Report State -->
    <div class="header">
      <h1>🔒 Trivy Security Report</h1>
      <div class="timestamp">Generated: {{ now }}</div>
    </div>
    <div class="empty-state" style="padding: 4rem;">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="80" height="80">
        <path d="M9 12h6m-6 4h6m2 5H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5.586a1 1 0 0 1 .707.293l5.414 5.414a1 1 0 0 1 .293.707V19a2 2 0 0 1-2 2z"/>
      </svg>
      <h3>No security issues found</h3>
      <p style="margin-top: 1rem;">Your target is clean! 🎉</p>
    </div>
    {{- end }}

    <!-- Footer -->
    <div class="footer">
      <p>Generated by Trivy | Scan performed on {{ now }}</p>
      <p style="margin-top: 0.5rem; font-size: 0.75rem;">This report is for informational purposes only.</p>
    </div>
  </div>
</body>
</html>
