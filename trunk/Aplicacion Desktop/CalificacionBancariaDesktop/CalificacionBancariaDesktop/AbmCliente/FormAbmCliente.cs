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
        SqlDataAdapter da;
        DataTable dt = new DataTable();

        public FormAbmCliente()
        {
            InitializeComponent();
            fillBancos(); //Cargar comboBox
        }

        private void FormAbmCliente_Load(object sender, EventArgs e)
        {
            string sCnn;
            sCnn = ConfigurationManager.AppSettings["connection_string"];

            string sSel = "SELECT * FROM gd_esquema.clientes";

            try
            {
                da = new SqlDataAdapter(sSel, sCnn);
                da.Fill(dt);
                this.dgvClientes.DataSource = dt;
                da.Dispose();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }

        private void buttonDelete_Click(object sender, EventArgs e)
        {
            if (this.dgvClientes.SelectedRows.Count != 1)
                MessageBox.Show("You have select one row to delete", "Alert", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            else
            {
                DialogResult dlgRes = MessageBox.Show("Are you sure you want to delete this haulunit ?", "Alert", MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation);
                if (dlgRes == DialogResult.OK)
                {
                    try
                    {
                        long id = (Int64)this.dgvClientes.SelectedRows[0].Cells["ID"].Value;
                        //SQL DELETE
                    }
                    catch
                    {
                        MessageBox.Show("Error while deleting the Haulunit", "Error", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    }
                }
            }
        }

        private void buttonEdit_Click(object sender, EventArgs e)
        {
            if (this.dgvClientes.SelectedRows.Count != 1)
                MessageBox.Show("You have select one row to edit", "Alert", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            else
            {
                try
                {
                    long id = (Int64)this.dgvClientes.SelectedRows[0].Cells["ID"].Value;
                    //SQL UPDATE
                }
                catch
                {
                    MessageBox.Show("Error while loading the Haulunit", "Error", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                }
            }
        }

        private void fillBancos()
        {
            string sCnn;
            sCnn = ConfigurationManager.AppSettings["connection_string"];

            string sSelCombo1 = "SELECT BANC_ID,BANC_NOM FROM gd_esquema.Bancos";

            SqlDataAdapter da;
            DataTable dtCombo1 = new DataTable();

            try
            {
                da = new SqlDataAdapter(sSelCombo1, sCnn);
                da.Fill(dtCombo1);
                this.comboBox1.DataSource = dtCombo1;
                da.Dispose();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }

        private void buttonAdd_Click(object sender, EventArgs e)
        {
            // Crear un nuevo registro
            DataRow dr = dt.NewRow();
            // Asignar los datos de los textbox a la fila
            dr["CLI_NOMB"] = txtNombre.Text;
            dr["CLI_APELLIDO"] = txtApellido.Text;
            dr["CLI_DNI"] = txtDNI.Text;
            dr["CLI_MAIL"] = txtMail.Text;

            // Añadir la nueva fila a la tabla
            dt.Rows.Add(dr);
            // Guardar físicamente los datos en la base
            try
            {
                da.Update(dt);
                dt.AcceptChanges();
                // Si es el primer registro de la base,
                // volver a leer los datos para actualizar los IDs
                if (Convert.ToInt32("0" + dr["ID"].ToString()) == 0)
                {
                    dt = new DataTable();
                    da.Fill(dt);
                }
            }
            catch (DBConcurrencyException ex)
            {
                MessageBox.Show("Error de concurrencia:\n" + ex.Message);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }


        }
    }
}