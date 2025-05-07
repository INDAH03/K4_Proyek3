<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Family Aquarium</title>
    <style>
        :root {
            --primary-color: #28a745;
            --secondary-color: #343a40;
            --light-color: #f8f9fa;
            --dark-color: #495057;
            --text-color: #212529;
            --text-light: #6c757d;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            color: var(--text-color);
        }
        
        .dashboard-container {
            display: flex;
            min-height: 100vh;
            background-color: var(--light-color);
        }
        
        /* Sidebar styling */
        .sidebar {
            width: 250px;
            background-color: var(--secondary-color);
            color: white;
            padding: 20px 0;
            transition: all 0.3s;
            display: flex;
            flex-direction: column;
        }
        
        .brand {
            padding: 0 20px 20px;
            font-size: 24px;
            font-weight: bold;
            color: var(--primary-color);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }
        
        .menu {
            list-style: none;
            padding: 0;
            margin: 0;
            flex: 1;
        }
        
        .menu-item {
            padding: 12px 20px;
            display: flex;
            align-items: center;
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            transition: all 0.3s;
            border-left: 3px solid transparent;
        }
        
        .menu-item i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }
        
        .menu-item:hover, .menu-item.active {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
            border-left: 3px solid var(--primary-color);
        }
        
        .logout-container {
            padding: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .logout-btn {
            display: flex;
            align-items: center;
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            transition: all 0.3s;
            padding: 10px;
            border-radius: 4px;
        }
        
        .logout-btn:hover {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
        }
        
        .logout-btn i {
            margin-right: 10px;
        }
        
        /* Main content area */
        .content {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
        }
        
        /* Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        }
        
        .header h1 {
            font-size: 24px;
            margin: 0;
            color: var(--secondary-color);
        }
        
        .date-display {
            color: var(--text-light);
            font-size: 14px;
            margin-top: 5px;
        }
        
        .search {
            position: relative;
            width: 250px;
        }
        
        .search input {
            width: 100%;
            padding: 8px 15px;
            border: 1px solid #ced4da;
            border-radius: 20px;
            font-size: 14px;
            background-color: white;
        }
        
        .search-btn {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--text-light);
            cursor: pointer;
        }
        
        /* Stats cards */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card h3 {
            font-size: 16px;
            color: var(--text-light);
            margin-top: 0;
            margin-bottom: 10px;
        }
        
        .stat-card .value {
            font-size: 28px;
            font-weight: bold;
            color: var(--secondary-color);
            margin-bottom: 5px;
        }
        
        .stat-card .description {
            font-size: 14px;
            color: var(--text-light);
        }
        
        /* Main content grid */
        .main-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
        }
        
        @media (max-width: 992px) {
            .main-content {
                grid-template-columns: 1fr;
            }
        }
        
        /* Cards styling */
        .card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }
        
        .card-title {
            font-size: 18px;
            color: var(--secondary-color);
            margin-top: 0;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        /* Chart container */
        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }
        
        /* Table styling */
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }
        
        .table th {
            background-color: var(--light-color);
            color: var(--dark-color);
            padding: 12px 15px;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid rgba(0, 0, 0, 0.1);
        }
        
        .table td {
            padding: 12px 15px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
            color: var(--dark-color);
        }
        
        .table tr:last-child td {
            border-bottom: none;
        }
        
        .table tr:hover td {
            background-color: rgba(0, 0, 0, 0.02);
        }
        
        /* Status badges */
        .badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .badge-success {
            background-color: #d4edda;
            color: #155724;
        }
        
        .badge-warning {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .badge-danger {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        /* Buttons */
        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #218838;
            color: white;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }
        
        .view-all {
            display: inline-block;
            margin-top: 10px;
            color: var(--primary-color);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }
        
        .view-all:hover {
            text-decoration: underline;
        }
        
        /* Monitoring section */
        .monitoring-item {
            display: flex;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        .monitoring-item:last-child {
            border-bottom: none;
        }
        
        .monitoring-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: rgba(40, 167, 69, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: var(--primary-color);
        }
        
        .monitoring-info {
            flex: 1;
        }
        
        .monitoring-title {
            font-weight: 500;
            margin-bottom: 3px;
        }
        
        .monitoring-status {
            font-size: 12px;
            color: var(--text-light);
        }
        
        /* Water quality indicators */
        .water-quality {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
        }
        
        .quality-indicator {
            text-align: center;
            flex: 1;
            padding: 10px;
        }
        
        .quality-value {
            font-size: 24px;
            font-weight: bold;
            margin: 5px 0;
        }
        
        .quality-label {
            font-size: 12px;
            color: var(--text-light);
        }
        
        /* Progress bars */
        .progress {
            height: 8px;
            background-color: #e9ecef;
            border-radius: 4px;
            margin-top: 5px;
        }
        
        .progress-bar {
            background-color: var(--primary-color);
            border-radius: 4px;
        }
        
        .turbidity-indicator {
            width: 100%;
            height: 20px;
            background: linear-gradient(to right, #28a745, #ffc107, #dc3545);
            border-radius: 10px;
            margin-top: 10px;
            position: relative;
        }
        
        .turbidity-marker {
            position: absolute;
            top: -15px;
            width: 2px;
            height: 20px;
            background-color: #343a40;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="brand">Family Aquarium</div>
            <ul class="menu">
                <li class="menu-item active"><i class="fas fa-home"></i> Dashboard</li>
                <li class="menu-item"><i class="fas fa-users"></i> Data Pengguna</li>
                <li class="menu-item"><i class="fas fa-exchange-alt"></i> Transaksi</li>
                <li class="menu-item"><i class="fas fa-tint"></i> Kualitas Air</li>
                <li class="menu-item"><i class="fas fa-database"></i> Data Akuarium</li>
                <li class="menu-item"><i class="fas fa-file-alt"></i> Laporan</li>
                <li class="menu-item"><i class="fas fa-cog"></i> Pengaturan</li>
            </ul>
            <div class="logout-container">
                <a href="#" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </aside>

        <main class="content">
            <header class="header">
                <div>
                    <h1>Dashboard</h1>
                    <div class="date-display">12th Oct 2023</div>
                </div>
                <div class="search">
                    <input type="text" placeholder="Search...">
                    <button class="search-btn"><i class="fas fa-search"></i></button>
                </div>
            </header>

            <div class="stats-container">
                <div class="stat-card">
                    <h3>Total Pengguna</h3>
                    <div class="value">1,245</div>
                    <div class="description">Pengguna terdaftar</div>
                </div>
                <div class="stat-card">
                    <h3>Akuarium Aktif</h3>
                    <div class="value">86</div>
                    <div class="description">Akuarium sedang dimonitor</div>
                </div>
                <div class="stat-card">
                    <h3>Kekeruhan Air</h3>
                    <div class="value">12.5 NTU</div>
                    <div class="description">Status: Normal</div>
                </div>
            </div>

            <div class="main-content">
                <div>
                    <!-- Water Quality Chart -->
                    <div class="card">
                        <h2 class="card-title">Monitoring Kekeruhan Air</h2>
                        <div class="chart-container">
                            <canvas id="turbidityChart"></canvas>
                        </div>
                        <div class="turbidity-indicator">
                            <div class="turbidity-marker" style="left: 30%;"></div>
                        </div>
                        <div style="display: flex; justify-content: space-between; margin-top: 5px;">
                            <span style="font-size: 12px;">Jernih</span>
                            <span style="font-size: 12px;">Sedang</span>
                            <span style="font-size: 12px;">Keruh</span>
                        </div>
                    </div>

                    <!-- Products Section -->
                    <div class="card">
                        <h2 class="card-title">Produk</h2>
                        <table class="table">
                            <tr>
                                <th>Produk</th>
                                <th>Stok</th>
                                <th>Status</th>
                            </tr>
                            <tr>
                                <td>Ikan Arwana</td>
                                <td>2</td>
                                <td><span class="badge badge-warning">Hampir Habis</span></td>
                            </tr>
                            <tr>
                                <td>Aerator</td>
                                <td>0</td>
                                <td><span class="badge badge-danger">Kosong</span></td>
                            </tr>
                            <tr>
                                <td>Pakan Ikan</td>
                                <td>15</td>
                                <td><span class="badge badge-success">Tersedia</span></td>
                            </tr>
                            <tr>
                                <td>Filter Air</td>
                                <td>7</td>
                                <td><span class="badge badge-success">Tersedia</span></td>
                            </tr>
                        </table>
                        <a href="{{ route('admin.products.index') }}" class="view-all">Lihat Semua Produk</a>
                    </div>
                </div>

                <div>
                    <!-- Delivery Schedule -->
                    <div class="card">
                        <h2 class="card-title">Jadwal Pengantaran</h2>
                        <table class="table">
                            <tr>
                                <th>Produk</th>
                                <th>Penerima</th>
                                <th>Status</th>
                            </tr>
                            <tr>
                                <td>Ikan Arwana</td>
                                <td>Indah</td>
                                <td><span class="badge badge-success">Terkirim</span></td>
                            </tr>
                            <tr>
                                <td>Aerator</td>
                                <td>Maria</td>
                                <td><span class="badge badge-warning">Proses</span></td>
                            </tr>
                            <tr>
                                <td>Pakan Ikan</td>
                                <td>Budi</td>
                                <td><span class="badge badge-danger">Pending</span></td>
                            </tr>
                        </table>
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <p style="margin: 0;">Total Pengiriman: 3</p>
                            <a href="{{ route('admin.delivery-schedules') }}" class="btn btn-primary btn-sm">Atur Pengantaran</a>
                        </div>
                    </div>

                    <!-- Water Quality Monitoring -->
                    <div class="card">
                        <h2 class="card-title">Parameter Kualitas Air</h2>
                        <div class="water-quality">
                            <div class="quality-indicator">
                                <div class="quality-label">pH Air</div>
                                <div class="quality-value">7.2</div>
                                <div class="badge badge-success">Normal</div>
                            </div>
                            <div class="quality-indicator">
                                <div class="quality-label">Suhu</div>
                                <div class="quality-value">26°C</div>
                                <div class="badge badge-success">Normal</div>
                            </div>
                            <div class="quality-indicator">
                                <div class="quality-label">Oksigen</div>
                                <div class="quality-value">6.8 mg/L</div>
                                <div class="badge badge-warning">Perlu Perhatian</div>
                            </div>
                        </div>
                    </div>

                    <!-- Aquarium Status -->
                    <div class="card">
                        <h2 class="card-title">Status Akuarium</h2>
                        <div class="monitoring-item">
                            <div class="monitoring-icon">
                                <i class="fas fa-tint"></i>
                            </div>
                            <div class="monitoring-info">
                                <div class="monitoring-title">Akuarium Utama</div>
                                <div class="monitoring-status">Kekeruhan: 12.5 NTU</div>
                                <div class="progress">
                                    <div class="progress-bar" style="width: 30%"></div>
                                </div>
                            </div>
                        </div>
                        <div class="monitoring-item">
                            <div class="monitoring-icon">
                                <i class="fas fa-tint"></i>
                            </div>
                            <div class="monitoring-info">
                                <div class="monitoring-title">Akuarium Ikan Hias</div>
                                <div class="monitoring-status">Kekeruhan: 18.2 NTU</div>
                                <div class="progress">
                                    <div class="progress-bar" style="width: 45%"></div>
                                </div>
                            </div>
                        </div>
                        <a href="#" class="btn btn-primary btn-sm" style="width: 100%; margin-top: 10px;">Refresh Data</a>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // Turbidity Chart
        const turbidityCtx = document.getElementById('turbidityChart').getContext('2d');
        const turbidityChart = new Chart(turbidityCtx, {
            type: 'line',
            data: {
                labels: Array.from({length: 24}, (_, i) => `${i}:00`),
                datasets: [{
                    label: 'Kekeruhan Air (NTU)',
                    data: [10.2, 9.8, 9.5, 9.3, 9.1, 9.0, 9.2, 9.5, 10.1, 11.5, 12.8, 13.5, 
                           14.2, 14.8, 15.2, 15.5, 15.3, 14.8, 14.2, 13.5, 12.8, 12.0, 11.5, 11.0],
                    backgroundColor: 'rgba(40, 167, 69, 0.1)',
                    borderColor: 'rgba(40, 167, 69, 1)',
                    borderWidth: 2,
                    tension: 0.3,
                    fill: true,
                    pointBackgroundColor: 'rgba(40, 167, 69, 1)',
                    pointRadius: 3,
                    pointHoverRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return `Kekeruhan: ${context.parsed.y} NTU`;
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: false,
                        min: 5,
                        max: 20,
                        grid: {
                            drawBorder: false,
                            color: 'rgba(0, 0, 0, 0.05)'
                        },
                        title: {
                            display: true,
                            text: 'NTU'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>