using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace CalificacionBancariaDesktop.TransaccionEntreCuentas
{
    public partial class FormTransaccionEntreCuentas : Form
    {
        public FormTransaccionEntreCuentas()
        {
            InitializeComponent();
        }

        private void FormTransaccionEntreCuentas_Load(object sender, EventArgs e)
        {

        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            try
            {
                FormBuscarCuenta form = new FormBuscarCuenta();
                ShowForm(form);
            }
            catch
            {
                MessageBox.Show("Error while loading the Haulunit", "Error", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            } 
        }

        private void ShowForm(FormBuscarCuenta form)
        {
            this.Hide();
            form.ShowDialog();
            this.Show();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                FormBuscarCuenta form = new FormBuscarCuenta();
                ShowForm(form);
            }
            catch
            {
                MessageBox.Show("Error while loading the Haulunit", "Error", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            } 
        }
    }
}