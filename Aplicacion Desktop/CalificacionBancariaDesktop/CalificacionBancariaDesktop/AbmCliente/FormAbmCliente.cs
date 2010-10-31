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
                DialogResult dlgRes = MessageBox.Show("Are you sure you want to delete this client ?", "Alert", MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation);
                if (dlgRes == DialogResult.OK)
                {
                    try
                    {
                        long id = (Int64)this.dgvClientes.SelectedRows[0].Cells["CLI_COD"].Value;
                        string queryString = "UPDATE gd_esquema.clientes SET ENABLED=false WHERE CLI_COD = @idCliente";
                        SqlConnection connection = new SqlConnection(ConfigurationManager.AppSettings["connection_string"]);
                        SqlCommand command = new SqlCommand(queryString, connection);
                        command.Parameters.AddWithValue("@idCliente", id);
                        try
                        {
                            connection.Open();
                            int cmd = command.ExecuteNonQuery();
                            this.dgvClientes.Refresh();
                        }
                        catch (Exception ex)
                        {
                            MessageBox.Show(ex.Message);
                        }
                        
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
                    long id = (Int64)this.dgvClientes.SelectedRows[0].Cells["CLI_COD"].Value;
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

            string sSel = "SELECT BANC_NOM FROM gd_esquema.bancos";

            try
            {
                da = new SqlDataAdapter(sSel, sCnn);
                da.Fill(dt);
                this.comboBox1.DataSource = dt;
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
            dr["CLI_DNI"] = Convert.ToInt32(txtDNI.Text);
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

/*
string connectionString =
    "Data Source=(local);Initial Catalog=Northwind;"
    + "Integrated Security=true";

// Provide the query string with a parameter placeholder.
string queryString =
    "SELECT ProductID, UnitPrice, ProductName from dbo.products "
        + "WHERE UnitPrice > @pricePoint "
        + "ORDER BY UnitPrice DESC;";

// Specify the parameter value.
int paramValue = 5;

// Create and open the connection in a using block. This
// ensures that all resources will be closed and disposed
// when the code exits.
using (SqlConnection connection =
    new SqlConnection(connectionString))
{
    // Create the Command and Parameter objects.
    SqlCommand command = new SqlCommand(queryString, connection);
    command.Parameters.AddWithValue("@pricePoint", paramValue);

    // Open the connection in a try/catch block. 
    // Create and execute the DataReader, writing the result
    // set to the console window.
    try
    {
        connection.Open();
        SqlDataReader reader = command.ExecuteReader();
        while (reader.Read())
        {
            Console.WriteLine("\t{0}\t{1}\t{2}",
                reader[0], reader[1], reader[2]);
        }
        reader.Close();
    }
    catch (Exception ex)
    {
        Console.WriteLine(ex.Message);
    }
    Console.ReadLine();
*/