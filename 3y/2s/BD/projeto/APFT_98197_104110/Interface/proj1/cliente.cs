using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.ComponentModel.Design.ObjectSelectorEditor;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace proj1
{
    public partial class cliente : Form
    {
        private SqlConnection cn;

        public cliente()
        {
            InitializeComponent();
        }
        private void cliente_Load(object sender, EventArgs e)
        {
            cn = getSGBDConnection();
        }
        

        private SqlConnection getSGBDConnection()
        {
            string dbServer = "tcp:mednat.ieeta.pt\\SQLSERVER,8101";
            string dbName = "p7g5";
            string userName = "p7g5";
            string userPass = "228961584@BD!";
            return new SqlConnection("Data Source = " + dbServer + " ;" + "Initial Catalog = " + dbName + "; uid = " + userName + ";" + "password = " + userPass);

        }
        private bool verifySGBDConnection()
        {
            if (cn == null)
                cn = getSGBDConnection();

            if (cn.State != ConnectionState.Open)
                cn.Open();

            return cn.State == ConnectionState.Open;
        }


        private void guna2Button4_Click(object sender, EventArgs e)
        {
            this.Close();

            projetoCliente projetoCliente = new projetoCliente();

            // Display Form1
            projetoCliente.Show();
        }

        private void guna2Button2_Click(object sender, EventArgs e)
        {
            this.Close();

            Form1 form1 = new Form1();

            // Display Form1
            form1.Show();
        }

        private void guna2Button3_Click(object sender, EventArgs e)
        {
            this.Close();

            Material Material = new Material();

            // Display Form1
            Material.Show();
        }

        private void guna2Button1_Click(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void guna2GradientButton1_Click(object sender, EventArgs e)
        {
            this.Close();

            AddCliente AddCliente = new AddCliente();

            // Display Form1
            AddCliente.Show();
        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void dataGridViewInfClientes_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void numericUpDown3_ValueChanged(object sender, EventArgs e)
        {

        }

        //Este é para a info do cliente por projeto selecionado
        private void button4_Click(object sender, EventArgs e)
        {
            dataGridViewSalarioSup.Rows.Clear();
            dataGridViewSalarioSup.Columns.Clear(); // Limpa as colunas existentes

            // Obter salário a pesquisar da caixa de texto
            if (decimal.TryParse(numericUpDown2.Text, out decimal projetoID))
            {
                try
                {
                    cn.Open();

                    // Utilizar a função
                    SqlCommand cmd = new SqlCommand("SELECT * FROM ListarClientePorProjeto(@projetoID)", cn);
                    cmd.Parameters.AddWithValue("@projetoID", projetoID);

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.HasRows)
                    {
                        // Adicionar colunas ao DataGridView
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            dataGridViewSalarioSup.Columns.Add(reader.GetName(i), reader.GetName(i));
                        }

                        while (reader.Read())
                        {
                            // Adicionar os dados às linhas
                            object[] rowData = new object[reader.FieldCount];
                            reader.GetValues(rowData);
                            dataGridViewSalarioSup.Rows.Add(rowData);
                        }
                    }
                    else
                    {
                        MessageBox.Show("O projeto esse ID não existe!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }

                    reader.Close();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Error: {ex.Message}");
                }
                finally
                {
                    cn.Close();
                }
            }
            else
            {
                MessageBox.Show("O ID do projeto é um inteiro", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            SqlCommand getFuncs = new SqlCommand("select p.Nome, c.projeto, p.Mail, p.CC, p.NIF, p.Telemovel, c.Localizacao from cliente c join pessoa p on p.NIF = c.FK_NIF;", cn);

            SqlDataReader reader = null;

            try
            {
                cn.Open();

                reader = getFuncs.ExecuteReader();

                dataGridViewTodosClientes.Rows.Clear();
                dataGridViewTodosClientes.Columns.Clear(); // Limpa as colunas existentes

                if (reader.HasRows)
                {
                    // Adicionar colunas ao DataGridView
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        dataGridViewTodosClientes.Columns.Add(reader.GetName(i), reader.GetName(i));
                    }

                    while (reader.Read())
                    {
                        // Adicionar os dados às linhas
                        object[] rowData = new object[reader.FieldCount];
                        reader.GetValues(rowData);
                        dataGridViewTodosClientes.Rows.Add(rowData);
                    }
                }
                else
                {
                MessageBox.Show("Não foram encontrados clientes!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }

                // Remover a primeira coluna se estiver vazia
                if (dataGridViewTodosClientes.Rows.Count > 0 && string.IsNullOrEmpty(dataGridViewTodosClientes.Rows[0].Cells[0].Value?.ToString()))
                {
                    dataGridViewTodosClientes.Columns.RemoveAt(0);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error: {ex.Message}");
            }
            finally
            {
                reader?.Close();
                cn.Close();
            }
        }


        private void dataGridViewTodosClientes_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void guna2Button5_Click(object sender, EventArgs e)
        {
            this.Close();
            AddRmv AddRmv = new AddRmv();

            // Display Form1
            AddRmv.Show();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            SqlCommand getFuncs = new SqlCommand("SELECT * FROM Caracteristicas_Projetos_Clientes;", cn);

            SqlDataReader reader = null;
            try
            {
                cn.Open();

                reader = getFuncs.ExecuteReader();

                dataGridViewTodosClientes.Rows.Clear();
                dataGridViewTodosClientes.Columns.Clear(); // Limpa as colunas existentes

                if (reader.HasRows)
                {
                    // Adicionar colunas ao DataGridView
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        dataGridViewTodosClientes.Columns.Add(reader.GetName(i), reader.GetName(i));
                    }

                    while (reader.Read())
                    {
                        // Adicionar os dados às linhas
                        object[] rowData = new object[reader.FieldCount];
                        reader.GetValues(rowData);
                        dataGridViewTodosClientes.Rows.Add(rowData);
                    }
                }
                else
                {
                    MessageBox.Show("Não foram encontrados projetos!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);


                }

                // Remover a primeira coluna se estiver vazia
                if (dataGridViewTodosClientes.Rows.Count > 0 && string.IsNullOrEmpty(dataGridViewTodosClientes.Rows[0].Cells[0].Value?.ToString()))
                {
                    dataGridViewTodosClientes.Columns.RemoveAt(0);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error: {ex.Message}");
            }
            finally
            {
                reader?.Close();
                cn.Close();
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            
            SqlCommand getFuncs = new SqlCommand("SELECT * FROM Caracteristicas_Clientes_Sem_Projetos;", cn);

            SqlDataReader reader = null;
            try
            {
                cn.Open();

                reader = getFuncs.ExecuteReader();

                dataGridViewTodosClientes.Rows.Clear();
                dataGridViewTodosClientes.Columns.Clear(); // Limpa as colunas existentes

                if (reader.HasRows)
                {
                    // Adicionar colunas ao DataGridView
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        dataGridViewTodosClientes.Columns.Add(reader.GetName(i), reader.GetName(i));
                    }

                    while (reader.Read())
                    {
                        // Adicionar os dados às linhas
                        object[] rowData = new object[reader.FieldCount];
                        reader.GetValues(rowData);
                        dataGridViewTodosClientes.Rows.Add(rowData);
                    }
                }
                else
                {
                    MessageBox.Show("Não foram encontrados projetos!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);


                }

                // Remover a primeira coluna se estiver vazia
                if (dataGridViewTodosClientes.Rows.Count > 0 && string.IsNullOrEmpty(dataGridViewTodosClientes.Rows[0].Cells[0].Value?.ToString()))
                {
                    dataGridViewTodosClientes.Columns.RemoveAt(0);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error: {ex.Message}");
            }
            finally
            {
                reader?.Close();
                cn.Close();
            }
        }
    }


}
