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
    public partial class projetoCliente : Form
    {
        private SqlConnection cn;
        public projetoCliente()
        {
            InitializeComponent();
        }



        private void projetoCliente_Load(object sender, EventArgs e)
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


        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }
        private void button3_Click(object sender, EventArgs e)
        {
            
        }


        private void listBox3_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void guna2Button2_Click(object sender, EventArgs e)
        {
            this.Close();

            // Create an instance of Form1
            Form1 form1 = new Form1();

            // Display Form1
            form1.Show();
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

        private void guna2Button1_Click(object sender, EventArgs e)
        {

        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void panelContainer_Paint(object sender, PaintEventArgs e)
        {
        }

        private void button2_Click_1(object sender, EventArgs e)
        {
            
        }

        private void button3_Click_1(object sender, EventArgs e)
        {
        }

        private void textBox2_TextChanged_1(object sender, EventArgs e)
        {

        }

        private void numericUpDown1_ValueChanged(object sender, EventArgs e)
        {

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void button7_Click(object sender, EventArgs e)
        {
            this.Close();

            AddProjeto AddProjeto = new AddProjeto();

            AddProjeto.Show();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            
        }

        private void numericUpDown2_ValueChanged(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void PopupSend_Click(object sender, EventArgs e)
        {

        }

        // Declarar a variável de classe para armazenar o valor do orçamento
        private string orcamento = string.Empty;

        private void button4_Click(object sender, EventArgs e)
        {
            // Obter salário a pesquisar da caixa de texto
            if (decimal.TryParse(numericUpDown3.Text, out decimal projetoID))
            {
                try
                {
                    cn.Open();

                    // Consulta para obter o custo do material
                    SqlCommand cmdCustoMaterial = new SqlCommand("SELECT PrecoMaterial = SUM(m.Preco * n.Unidades) FROM ListarMateriaisProjeto(@ProjectID) n JOIN material m ON m.N_Referencia_Material = n.Referencia;", cn);
                    cmdCustoMaterial.Parameters.AddWithValue("@ProjectID", projetoID);
                    decimal custoMaterial = Convert.ToDecimal(cmdCustoMaterial.ExecuteScalar());

                    // Consulta para obter o número de funcionários
                    SqlCommand cmdNumFuncionarios = new SqlCommand("SELECT NumFuncionarios = COUNT(FK_NIF_Funcionario) FROM responsavel WHERE FK_ID_Projeto = @ProjectID;", cn);
                    cmdNumFuncionarios.Parameters.AddWithValue("@ProjectID", projetoID);
                    int numFuncionarios = Convert.ToInt32(cmdNumFuncionarios.ExecuteScalar());

                    // Consulta para obter a duração do projeto
                    SqlCommand cmdDuracao = new SqlCommand("SELECT Duracao = Duracao FROM projeto WHERE ID = @ProjectID;", cn);
                    cmdDuracao.Parameters.AddWithValue("@ProjectID", projetoID);
                    int duracaoProjeto = Convert.ToInt32(cmdDuracao.ExecuteScalar());

                    // Consulta para obter a distância total
                    SqlCommand cmdDistanciaTotal = new SqlCommand("SELECT dbo.Dist_Total(@ProjectID) AS DistanciaTotal;", cn);
                    cmdDistanciaTotal.Parameters.AddWithValue("@ProjectID", projetoID);
                    int distanciaTotal = Convert.ToInt32(cmdDistanciaTotal.ExecuteScalar());

                    // Utilizar a função
                    SqlCommand cmdOrcamento = new SqlCommand("SELECT dbo.CalcularOrcamento(@projetoID)", cn);
                    cmdOrcamento.Parameters.AddWithValue("@projetoID", projetoID);
                    object result = cmdOrcamento.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                    {
                        string orcamento = result.ToString();
                        listBoxCalculos.Items.Clear();
                        listBoxCalculos.Items.Add("Transporte: " + distanciaTotal+ " euros.");
                        listBoxCalculos.Items.Add("Duração do projeto: " + duracaoProjeto + " dias.");
                        listBoxCalculos.Items.Add("Número de funcionários: " + numFuncionarios +".");
                        listBoxCalculos.Items.Add("Custo dos materiais: " + custoMaterial+" euros.");
                        listBoxCalculos.Items.Add("Fórmula: Trasporte + Duração * Funcionários + Custo dos materiais");
                        listBoxCalculos.Items.Add("O orçamento do projeto " + projetoID + " fica a " + orcamento + " euros.");

                    }
                    else
                    {
                        MessageBox.Show($"Não foi possível obter o orçamento do projeto {projetoID}.", "Resultado", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Erro ao obter o orçamento ou ao obter a distância total do projeto, não se esqueça de inserir o ID!", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                finally
                {
                    cn.Close();
                }
            }
            else
            {
                MessageBox.Show("ID do projeto inválido. Por favor, insira um ID válido.", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }


        private void guna2Button5_Click(object sender, EventArgs e)
        {
            this.Close();
            AddRmv AddRmv = new AddRmv();

            // Display Form1
            AddRmv.Show();
        }

        private void listBoxCalculos_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void siticoneTextBox1_TextChanged(object sender, EventArgs e)
        {
            
        }

        private void siticoneTextBox1_KeyPress(object sender, KeyPressEventArgs e)
        {
            cn = getSGBDConnection();
            if (siticoneTextBox1.Text != "")
            {
                string query = "SELECT ID as ID_Projeto, pe.Nome AS Nome_Cliente, N_Janelas, N_Portas, N_Portadas, Duracao, Data_conclusao, c.FK_NIF AS NIF_Cliente " +
                    "FROM projeto p " +
                    "JOIN cliente c ON p.FK_NIF_Cliente = c.FK_NIF " +
                    "JOIN pessoa pe ON c.FK_NIF = pe.NIF " +
                    "where ID like '%"+ siticoneTextBox1.Text + "%' or pe.Nome like '%" + siticoneTextBox1.Text+ "%'";

                cn.Open();
                SqlCommand cmdCustoMaterial = new SqlCommand(query,cn);
                SqlDataReader reader = cmdCustoMaterial.ExecuteReader();
                DataTable table = new DataTable();
                table.Load(reader);
                dataGridViewTodosClientes.DataSource = table;
                cn.Close();
            } else if (siticoneTextBox1.Text == ""){
                // here we refresh
                string query = "SELECT ID as ID_Projeto, pe.Nome AS Nome_Cliente, N_Janelas, N_Portas, N_Portadas, Duracao, Data_conclusao, c.FK_NIF AS NIF_Cliente from projeto p join cliente c on p.FK_NIF_Cliente = c.FK_NIF JOIN pessoa pe ON c.FK_NIF = pe.NIF";
                cn.Open();
                SqlCommand cmdCustoMaterial = new SqlCommand(query, cn);
                SqlDataReader reader = cmdCustoMaterial.ExecuteReader();
                DataTable table = new DataTable();
                table.Load(reader);
                dataGridViewTodosClientes.DataSource = table;
                cn.Close();
            }
        }
    }
}
