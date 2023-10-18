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
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace proj1
{
    public partial class Material : Form
    {
        private SqlConnection cn;
        public Material()
        {
            InitializeComponent();
        }

        private void Material_Load(object sender, EventArgs e)
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


        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            
        }

        private void listBox4_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        // Projeto
        private void guna2Button3_Click(object sender, EventArgs e)
        {
            this.Close();

            projetoCliente projetoCliente = new projetoCliente();

            // Display Form1
            projetoCliente.Show();
        }

        // Material
        private void guna2Button1_Click(object sender, EventArgs e)
        {

        }
        //CLiente
        private void guna2Button4_Click(object sender, EventArgs e)
        {
            this.Close();

            cliente cliente = new cliente();

            // Display Form1
            cliente.Show();
        }
        // Funcionario
        private void guna2Button2_Click(object sender, EventArgs e)
        {
            this.Close();

            // Create an instance of Form1
            Form1 form1 = new Form1();

            // Display Form1
            form1.Show();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            dataGridViewInfMat.Rows.Clear();
            dataGridViewInfMat.Columns.Clear(); // Limpa as colunas existentes

            // Obter salário a pesquisar da caixa de texto
            if (decimal.TryParse(numericUpDown2.Text, out decimal projetoID))
            {
                try
                {
                    cn.Open();

                    // Utilizar a função
                    SqlCommand cmd = new SqlCommand("SELECT * FROM ListarMateriaisProjeto(@projetoID)", cn);
                    cmd.Parameters.AddWithValue("@projetoID", projetoID);

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.HasRows)
                    {
                        // Adicionar colunas ao DataGridView
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            dataGridViewInfMat.Columns.Add(reader.GetName(i), reader.GetName(i));
                        }

                        while (reader.Read())
                        {
                            // Adicionar os dados às linhas
                            object[] rowData = new object[reader.FieldCount];
                            reader.GetValues(rowData);
                            dataGridViewInfMat.Rows.Add(rowData);
                        }
                    }
                    else
                    {
                        MessageBox.Show("Projeto com esse ID não existe!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);

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
                MessageBox.Show("Projeto inválido. Por favor insira um projeto em número inteiro!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            dataGridViewLimitePreco.Rows.Clear();
            dataGridViewLimitePreco.Columns.Clear(); // Limpa as colunas existentes

            // Obter salário a pesquisar da caixa de texto
            if (decimal.TryParse(numericUpDownMaxPrice.Text, out decimal max))
            {
                // Verificar se a textBox e o comboBox estão vazios
                if (string.IsNullOrWhiteSpace(numericUpDownMaxPrice.Text) && string.IsNullOrWhiteSpace(comboBox1.Text))
                {
                    MessageBox.Show("Por favor, insira um valor máximo de preço e uma designação para pesquisar.");
                    return; // Sai do evento após exibir a mensagem informativa
                }

                try
                {
                    cn.Open();

                    // Utilizar a função
                    string designacao = comboBox1.Text;

                    SqlCommand cmd = new SqlCommand("SELECT * FROM ListarMateriaisPorPreco(@PrecoLimite, @Designacao)", cn);
                    cmd.Parameters.AddWithValue("@PrecoLimite", max);
                    cmd.Parameters.AddWithValue("@Designacao", designacao);

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.HasRows)
                    {
                        // Adicionar colunas ao DataGridView
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            dataGridViewLimitePreco.Columns.Add(reader.GetName(i), reader.GetName(i));
                        }

                        while (reader.Read())
                        {
                            // Adicionar os dados às linhas
                            object[] rowData = new object[reader.FieldCount];
                            reader.GetValues(rowData);
                            dataGridViewLimitePreco.Rows.Add(rowData);
                        }
                    }
                    else
                    {
                        MessageBox.Show("Não há materiais abaixo do preço " + max + ". Não se esqueça de inserir a designação!");
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
                MessageBox.Show("Salário inválido. Por favor insira um salário um número inteiro!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);

            }
        }


        private void button2_Click(object sender, EventArgs e)
        {
            dataGridViewForn.Rows.Clear();
            dataGridViewForn.Columns.Clear(); // Limpa as colunas existentes

            // Obter salário a pesquisar da caixa de texto
            if (decimal.TryParse(numericUpDown1.Text, out decimal projetoID))
            {
                try
                {
                    cn.Open();

                    // Utilizar a função
                    SqlCommand cmd = new SqlCommand("SELECT * FROM ObterDetalhesFornecedoresPorProjeto(@projetoID)", cn);
                    cmd.Parameters.AddWithValue("@projetoID", projetoID);

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.HasRows)
                    {
                        // Adicionar colunas ao DataGridView
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            dataGridViewForn.Columns.Add(reader.GetName(i), reader.GetName(i));
                        }

                        while (reader.Read())
                        {
                            // Adicionar os dados às linhas
                            object[] rowData = new object[reader.FieldCount];
                            reader.GetValues(rowData);
                            dataGridViewForn.Rows.Add(rowData);
                        }
                    }
                    else
                    {
                        MessageBox.Show("Não há fornecedores para esse projeto!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
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
                MessageBox.Show("Projeto inválido. Por favor insira um projeto em número inteiro!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void guna2Button5_Click(object sender, EventArgs e)
        {
            this.Close();
            AddRmv AddRmv = new AddRmv();

            // Display Form1
            AddRmv.Show();
        }

        private void btnEncomendas_Click_1(object sender, EventArgs e)
        {
            SqlCommand getFuncs = new SqlCommand("select Codigo, Data_Chegada, Unidades, FK_N_Referencia_Material from encomenda join contem on FK_Codigo = Codigo", cn);

            SqlDataReader reader = null;

            try
            {
                cn.Open();

                reader = getFuncs.ExecuteReader();

                ViewEncomendas.Rows.Clear();
                ViewEncomendas.Columns.Clear(); // Limpa as colunas existentes

                if (reader.HasRows)
                {
                    // Adicionar colunas ao DataGridView
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        ViewEncomendas.Columns.Add(reader.GetName(i), reader.GetName(i));
                    }

                    while (reader.Read())
                    {
                        // Adicionar os dados às linhas
                        object[] rowData = new object[reader.FieldCount];
                        reader.GetValues(rowData);
                        ViewEncomendas.Rows.Add(rowData);
                    }
                }
                else
                {
                MessageBox.Show("Não foram encontrados encomendas!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }

                // Remover a primeira coluna se estiver vazia
                if (ViewEncomendas.Rows.Count > 0 && string.IsNullOrEmpty(ViewEncomendas.Rows[0].Cells[0].Value?.ToString()))
                {
                    ViewEncomendas.Columns.RemoveAt(0);
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

        private void btnForn_Click(object sender, EventArgs e)
        {
            
            SqlCommand getFuncs = new SqlCommand("SELECT NIF, Nome, IBAN, Localizacao, Distancia, Telefone FROM fornecedor;", cn);

            SqlDataReader reader = null;

            try
            {
                cn.Open();

                reader = getFuncs.ExecuteReader();

                ViewEncomendas.Rows.Clear();
                ViewEncomendas.Columns.Clear(); // Limpa as colunas existentes

                if (reader.HasRows)
                {
                    // Adicionar colunas ao DataGridView
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        ViewEncomendas.Columns.Add(reader.GetName(i), reader.GetName(i));
                    }

                    while (reader.Read())
                    {
                        // Adicionar os dados às linhas
                        object[] rowData = new object[reader.FieldCount];
                        reader.GetValues(rowData);
                        ViewEncomendas.Rows.Add(rowData);
                    }
                }
                else
                {
                MessageBox.Show("Não foram encontrados Fornecedores!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }

                // Remover a primeira coluna se estiver vazia
                if (ViewEncomendas.Rows.Count > 0 && string.IsNullOrEmpty(ViewEncomendas.Rows[0].Cells[0].Value?.ToString()))
                {
                    ViewEncomendas.Columns.RemoveAt(0);
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

        private void dataGridViewInfMat_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
