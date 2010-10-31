using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Configuration;

namespace CalificacionBancariaDesktop.AbmCliente
{
    public partial class FormAbmCliente : Form
    {
        public FormAbmCliente()
        {
            InitializeComponent();
        }

        private void FormAbmCliente_Load(object sender, EventArgs e)
        {
            string sCnn;
            sCnn = ConfigurationManager.AppSettings["connection_string"];

            string sSel = "SELECT * FROM gd_esquema.Maestra WHERE BANC_NOM = 'Banco UTN'";

            SqlDataAdapter da;
            DataTable dt = new DataTable();

            try
            {
                da = new SqlDataAdapter(sSel, sCnn);
                da.Fill(dt);
                this.dataGridView1.DataSource = dt;
                da.Dispose();
                //this.dataGridView1.DataBind();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }
    }
}