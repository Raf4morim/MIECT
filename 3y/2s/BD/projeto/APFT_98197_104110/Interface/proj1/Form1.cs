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

namespace proj1
{
    public partial class Form1 : Form
    {
        private SqlConnection cn;
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
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

        private void button1_Click(object sender, EventArgs e)
        {
            SqlCommand getFuncs = new SqlCommand("select Nome, Mail, CC, NIF, Seguro, Idade, Ordenado  from (funcionario f join pessoa p on p.NIF=f.FK_NIF);", cn);

            SqlDataReader reader = null;

            try
            {
                cn.Open();

                reader = getFuncs.ExecuteReader();

                dataGridViewTdsFuncionario.Rows.Clear();
                dataGridViewTdsFuncionario.Columns.Clear(); // Limpa as colunas existentes

                if (reader.HasRows)
                {
                    // Adicionar colunas ao DataGridView
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        dataGridViewTdsFuncionario.Columns.Add(reader.GetName(i), reader.GetName(i));
                    }

                    while (reader.Read())
                    {
                        // Adicionar os dados às linhas
                        object[] rowData = new object[reader.FieldCount];
                        reader.GetValues(rowData);
                        dataGridViewTdsFuncionario.Rows.Add(rowData);
                    }
                }
                else
                {
                MessageBox.Show("Não foram encontrados funcionários!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }

                // Remover a primeira coluna se estiver vazia
                if (dataGridViewTdsFuncionario.Rows.Count > 0 && string.IsNullOrEmpty(dataGridViewTdsFuncionario.Rows[0].Cells[0].Value?.ToString()))
                {
                    dataGridViewTdsFuncionario.Columns.RemoveAt(0);
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




        private void button2_Click(object sender, EventArgs e)
        {
            SqlCommand getFuncs = new SqlCommand("SELECT * FROM FuncionariosResponsaveisView ", cn);

            SqlDataReader reader = null;
            try
            {
                cn.Open();

                reader = getFuncs.ExecuteReader();

                dataGridViewFuncionSemProj.Rows.Clear();
                dataGridViewFuncionSemProj.Columns.Clear();

                if (reader.HasRows)
                {
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        dataGridViewFuncionSemProj.Columns.Add(reader.GetName(i), reader.GetName(i));
                    }

                    while (reader.Read())
                    {
                        object[] rowData = new object[reader.FieldCount];
                        reader.GetValues(rowData);
                        dataGridViewFuncionSemProj.Rows.Add(rowData);
                    }
                }
                else
                {
                    // Nenhum funcionário encontrado
                MessageBox.Show("Não foram encontrados funcionários!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }

                if (dataGridViewFuncionSemProj.Columns.Count > 0 && string.IsNullOrEmpty(dataGridViewFuncionSemProj.Rows[0].Cells[0].Value?.ToString()))
                {
                    dataGridViewFuncionSemProj.Columns.RemoveAt(0);
                }
            }
            catch (Exception ex)
            {
                dataGridViewFuncionSemProj.Rows.Add($"Erro: {ex.Message}");
            }
            finally
            {
                reader?.Close();
                cn.Close();
            }
        }


        private void button3_Click(object sender, EventArgs e)
        {
            SqlCommand getFuncs = new SqlCommand("SELECT * FROM FuncionariosSemResponsabilidadesView ", cn);

            SqlDataReader reader = null;
            try
            {
                cn.Open();

                reader = getFuncs.ExecuteReader();

                dataGridViewFuncionComProj.Rows.Clear();
                dataGridViewFuncionComProj.Columns.Clear(); // Limpa as colunas existentes

                if (reader.HasRows)
                {
                    // Adicionar colunas ao DataGridView
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        dataGridViewFuncionComProj.Columns.Add(reader.GetName(i), reader.GetName(i));
                    }

                    while (reader.Read())
                    {
                        // Adicionar os dados às linhas
                        object[] rowData = new object[reader.FieldCount];
                        reader.GetValues(rowData);
                        dataGridViewFuncionComProj.Rows.Add(rowData);
                    }

                    // Remover a primeira coluna se estiver vazia
                    if (dataGridViewFuncionComProj.Rows.Count > 0 && string.IsNullOrEmpty(dataGridViewFuncionComProj.Rows[0].Cells[0].Value?.ToString()))
                    {
                        dataGridViewFuncionComProj.Columns.RemoveAt(0);
                    }
                }
                else
                {
                MessageBox.Show("Não há funcionários sem projetos!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
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



        private void button4_Click(object sender, EventArgs e)
        {
            dataGridViewSalarioSup.Rows.Clear();
            dataGridViewSalarioSup.Columns.Clear(); // Limpa as colunas existentes

            // Obter salário a pesquisar da caixa de texto
            if (decimal.TryParse(textBox1.Text, out decimal salary))
            {
                try
                {
                    cn.Open();

                    // Utilizar a função
                    SqlCommand cmd = new SqlCommand("SELECT * FROM SalarioSuperior(@Salario)", cn);
                    cmd.Parameters.AddWithValue("@Salario", salary);

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
                        MessageBox.Show("Não há funcionários com salário superior a " + salary + "euros.");
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
                MessageBox.Show("Salário inválido. Por favor insira o salário é um número inteiro!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }


        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void guna2Button1_Click(object sender, EventArgs e)
        {

        }
        // Projeto
        private void guna2Button2_Click(object sender, EventArgs e)
        {
            this.Close();
            projetoCliente projetoCliente = new projetoCliente();

            // Display Form1
            projetoCliente.Show();
        }
        // Material
        private void guna2Button3_Click(object sender, EventArgs e)
        {
            this.Close();
            Material Material = new Material();

            // Display Form1
            Material.Show();
        }

        private void guna2Button4_Click(object sender, EventArgs e)
        {
            this.Close();
            cliente cliente = new cliente();

            // Display Form1
            cliente.Show();
        }

        private void dataGridViewFuncionComProj_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void button5_Click(object sender, EventArgs e)
        {

        }

        private void button6_Click(object sender, EventArgs e)
        {

        }

        private void guna2Button5_Click(object sender, EventArgs e)
        {
            this.Close();
            AddRmv AddRmv = new AddRmv();

            // Display Form1
            AddRmv.Show();
        }
    }
}
