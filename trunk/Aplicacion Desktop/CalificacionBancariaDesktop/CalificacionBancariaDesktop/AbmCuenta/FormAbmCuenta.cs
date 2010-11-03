using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace CalificacionBancariaDesktop.AbmCuenta
{
    public partial class FormAbmCuenta : Form
    {
        SqlDataAdapter da;
        DataTable dt = new DataTable();

        public FormAbmCuenta()
        {
            InitializeComponent();
        }

        private void buttonAdd_Click(object sender, EventArgs e)
        {
            // Crear un nuevo registro
            DataRow dr = dt.NewRow();
            // Asignar los datos de los textbox a la fila
            dr["CUE_COD"] = txtCUE_COD.Text;
            dr["CLI_ID"] = txtApellido.Text;
            dr["SUC_ID"] = Convert.ToInt32(txtDNI.Text);
            dr["FEC_CREA"] = DateTime.Now;
            dr["SALDO"] = txtMail.Text;

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

        private void btnView_Click(object sender, EventArgs e)
        {
            try
            {
                FormBuscarCliente form = new FormBuscarCliente();
                ShowForm(form);
            }
            catch
            {
                MessageBox.Show("Error while loading the Haulunit", "Error", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            } 
        }

        private void ShowForm(FormBuscarCliente form)
        {
            this.Hide();
            form.ShowDialog();
            this.Show();
        }
    }
}