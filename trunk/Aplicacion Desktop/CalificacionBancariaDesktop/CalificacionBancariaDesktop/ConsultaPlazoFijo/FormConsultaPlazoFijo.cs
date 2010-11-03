using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Configuration;

namespace CalificacionBancariaDesktop.ConsultaPlazoFijo
{
    public partial class FormConsultaPlazoFijo : Form
    {
        SqlDataAdapter da;
        DataTable dt = new DataTable();

        public FormConsultaPlazoFijo()
        {
            InitializeComponent();
        }

        private void FormConsultaPlazoFijo_Load(object sender, EventArgs e)
        {
            string sCnn;
            sCnn = ConfigurationManager.AppSettings["connection_string"];

            string sSel = "SELECT * CHUBY";

            try
            {
                da = new SqlDataAdapter(sSel, sCnn);
                da.Fill(dt);
                this.dgvPlazoFijo.DataSource = dt;
                da.Dispose();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }
    }
}