using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Configuration;

namespace CalificacionBancariaDesktop.OtorgacionPrestamos
{
    public partial class FormOtorgacionPrestamos : Form
    {
        public FormOtorgacionPrestamos()
        {
            InitializeComponent();
        }

        private void write_Click(object sender, EventArgs e)
        {
            string queryString = "QUERY CHUBY";
            SqlConnection connection = new SqlConnection(ConfigurationManager.AppSettings["connection_string"]);
            SqlCommand command = new SqlCommand(queryString, connection);
            try
            {
                connection.Open();
                int cmd = command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
    }
}