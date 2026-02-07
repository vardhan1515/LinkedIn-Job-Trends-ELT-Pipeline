async function loadJson(path) {
  const res = await fetch(path);
  if (!res.ok) throw new Error(`Failed to load ${path}`);
  return res.json();
}

function latestMonth(rows, key = 'month_start') {
  if (!rows.length) return null;
  const sorted = [...rows].sort((a, b) => (a[key] > b[key] ? -1 : 1));
  return sorted[0][key];
}

function renderList(containerId, rows, labelKey, valueKey, suffix = '') {
  const container = document.getElementById(containerId);
  if (!container) return;
  const list = document.createElement('div');
  list.className = 'list';
  rows.forEach((row) => {
    const item = document.createElement('div');
    item.className = 'item';
    const left = document.createElement('span');
    left.textContent = row[labelKey];
    const right = document.createElement('span');
    right.className = 'tag';
    right.textContent = `${row[valueKey]}${suffix}`;
    item.appendChild(left);
    item.appendChild(right);
    list.appendChild(item);
  });
  container.innerHTML = '';
  container.appendChild(list);
}

async function main() {
  const skills = await loadJson('data/skill_demand_monthly.json');
  const companies = await loadJson('data/top_companies_monthly.json');
  const roles = await loadJson('data/role_trends_monthly.json');
  const remote = await loadJson('data/remote_share_monthly.json');

  const latest = latestMonth(skills);
  const topSkills = skills.filter((r) => r.month_start === latest).slice(0, 8);
  renderList('skills', topSkills, 'skill', 'posting_count');

  const latestCompanies = latestMonth(companies);
  const topCompanies = companies.filter((r) => r.month_start === latestCompanies).slice(0, 8);
  renderList('companies', topCompanies, 'company_name', 'posting_count');

  const latestRoles = latestMonth(roles);
  const topRoles = roles.filter((r) => r.month_start === latestRoles).slice(0, 8);
  renderList('roles', topRoles, 'role', 'posting_count');

  const latestRemote = latestMonth(remote);
  const topRemote = remote.filter((r) => r.month_start === latestRemote).slice(0, 8);
  const formatted = topRemote.map((r) => ({
    role: r.role,
    remote_share: (r.remote_share * 100).toFixed(1) + '%'
  }));
  renderList('remote', formatted, 'role', 'remote_share');
}

main().catch((err) => {
  console.error(err);
});
