<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width,initial-scale=1" />
	<title>User List</title>
	<style>
		body{font-family:Segoe UI,Roboto,Helvetica,Arial;margin:24px}
		.container{max-width:980px;margin:0 auto}
		table{width:100%;border-collapse:collapse;margin-top:12px}
		th,td{padding:8px 10px;border:1px solid #e6e6e6;text-align:left}
		th{cursor:pointer;background:#fafafa}
		input[type=text]{padding:8px;width:300px;border:1px solid #ccc;border-radius:4px}
		.toolbar{display:flex;align-items:center;gap:12px}
		.muted{color:#666;font-size:0.9em}
	</style>
</head>
<body>
	<div class="container">
		<h1>User List</h1>
		<div class="toolbar">
			<input id="search" type="text" placeholder="Search name or email" oninput="applyFilter()" />
			<button onclick="addSampleUser()">Add sample user</button>
			<div class="muted">Showing <span id="count">0</span> users</div>
		</div>

		<table id="usersTable" aria-label="Users">
			<thead>
				<tr>
					<th onclick="sortBy('id')">ID</th>
					<th onclick="sortBy('name')">Name</th>
					<th onclick="sortBy('email')">Email</th>
					<th onclick="sortBy('role')">Role</th>
					<th>Actions</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>

	<script>
		const users = [
			{id:1,name:'Alice Johnson',email:'alice@example.com',role:'Admin'},
			{id:2,name:'Bob Lee',email:'bob.lee@example.com',role:'User'},
			{id:3,name:'Carla Gomez',email:'carla.g@example.com',role:'Manager'},
			{id:4,name:'Daniel Park',email:'danielp@example.com',role:'User'}
		];

		let current = users.slice();
		let sortState = {key:'id',asc:true};

		function render(){
			const tbody = document.querySelector('#usersTable tbody');
			tbody.innerHTML = '';
			const query = (document.getElementById('search').value || '').trim().toLowerCase();
			const filtered = current.filter(u=>{
				if(!query) return true;
				return u.name.toLowerCase().includes(query) || u.email.toLowerCase().includes(query);
			});
			filtered.forEach(u=>{
				const tr = document.createElement('tr');
				tr.innerHTML = `<td>${u.id}</td><td>${escapeHtml(u.name)}</td><td>${escapeHtml(u.email)}</td><td>${escapeHtml(u.role)}</td><td><button onclick="remove(${u.id})">Remove</button></td>`;
				tbody.appendChild(tr);
			});
			document.getElementById('count').textContent = filtered.length;
		}

		function applyFilter(){ render(); }

		function sortBy(key){
			if(sortState.key===key) sortState.asc = !sortState.asc; else { sortState.key = key; sortState.asc = true; }
			current.sort((a,b)=>{
				if(a[key] < b[key]) return sortState.asc ? -1 : 1;
				if(a[key] > b[key]) return sortState.asc ? 1 : -1;
				return 0;
			});
			render();
		}

		function addSampleUser(){
			const id = (current.reduce((s,u)=>Math.max(s,u.id),0) || 0) + 1;
			current.push({id,name:`New User ${id}`,email:`new${id}@example.com`,role:'User'});
			render();
		}

		function remove(id){
			const idx = current.findIndex(u=>u.id===id);
			if(idx>=0){ current.splice(idx,1); render(); }
		}

		function escapeHtml(s){ return String(s).replace(/[&<>"']/g,c=>({ '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;','\'':"&#39;" })[c]); }

		// initial sort and render
		sortBy('id');
	</script>
</body>
</html>
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="test3