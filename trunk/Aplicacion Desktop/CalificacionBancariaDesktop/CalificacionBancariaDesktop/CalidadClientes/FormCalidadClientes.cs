using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Configuration;

namespace CalificacionBancariaDesktop.CalidadClientes
{
    public partial class FormCalidadClientes : Form
    {
        SqlDataAdapter da;
        DataTable dt = new DataTable();

        public FormCalidadClientes()
        {
            InitializeComponent();
        }

        private void FormCalidadClientes_Load(object sender, EventArgs e)
        {
            string sCnn;
            sCnn = ConfigurationManager.AppSettings["connection_string"];

            string sSel = "SELECT * CHUBY";

            try
            {
                da = new SqlDataAdapter(sSel, sCnn);
                da.Fill(dt);
                this.dgvCalidadClientes.DataSource = dt;
                da.Dispose();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }
    }
}