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

namespace proj1
{
    public partial class AddEncomenda : Form
    {
        private SqlConnection cn;
        public AddEncomenda()
        {
            InitializeComponent();
        }

        private void AddEncomenda_Load(object sender, EventArgs e)
        {
            cn = getSGBDConnection();
            PopulateNIFDropdown();
        }
        private void PopulateNIFDropdown()
        {
            string queryMaterial = "select distinct N_Referencia_Material from material;";
            SqlCommand commandMaterial = new SqlCommand(queryMaterial, cn);


            cn.Open();

            SqlDataReader readerMaterial = commandMaterial.ExecuteReader();

            while (readerMaterial.Read())
            {
                string refMaterial = readerMaterial["N_Referencia_Material"].ToString();
                comboBoxRef.Items.Add(refMaterial);
            }

            readerMaterial.Close();

            cn.Close();
        }

        private SqlConnection getSGBDConnection()
        {
            string dbServer = "tcp:mednat.ieeta.pt\\SQLSERVER,8101";
            string dbName = "p7g5";
            string userName = "p7g5";
            string userPass = "228961584@BD!";
            return new SqlConnection("Data Source = " + dbServer + " ;" + "Initial Catalog = " + dbName + "; uid = " + userName + ";" + "password = " + userPass);
        }

        private void BtnEnviar_Click(object sender, EventArgs e)
        {
            // Get the input values from the user
            int codigoEncomenda;
            if (!int.TryParse(textIdentificacao.Text, out codigoEncomenda))
            {
                MessageBox.Show("Código de encomenda inválido. Certifique-se de que é um valor inteiro.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }

            DateTime dataChegada;
            if (!DateTime.TryParse(dateTimeChegada.Text, out dataChegada))
            {
                MessageBox.Show("Data de chegada inválida. Certifique-se de que está no formato correto (ex: dd-mm-yyyy).", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }

            if (dataGridView1.Rows.Count == 0)
            {
                MessageBox.Show("Preencha pelo menos uma linha na tabela de materiais.", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            // Create the SQL query to insert into the encomenda table
            string insertEncomendaQuery = "INSERT INTO encomenda (Codigo, Data_Chegada) VALUES (@Codigo, @DataChegada)";

            // Create the SqlCommand object for inserting into encomenda table
            SqlCommand insertEncomendaCommand = new SqlCommand(insertEncomendaQuery, cn);
            insertEncomendaCommand.Parameters.AddWithValue("@Codigo", codigoEncomenda);
            insertEncomendaCommand.Parameters.AddWithValue("@DataChegada", dataChegada);

            SqlTransaction transaction = null;

            try
            {
                // Open the database connection
                cn.Open();

                // Begin the transaction
                transaction = cn.BeginTransaction();

                // Assign the transaction to the commands
                insertEncomendaCommand.Transaction = transaction;

                // Execute the insert command for encomenda table
                insertEncomendaCommand.ExecuteNonQuery();

                // HashSet to store the added references
                HashSet<string> addedReferences = new HashSet<string>();

                if (dataGridView1.Rows.Count <= 1)
                {
                    MessageBox.Show("Preencha pelo menos uma linha na tabela de materiais.", "Caution", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return;
                }
                // Crie uma nova coluna DataGridViewTextBoxColumn
                DataGridViewTextBoxColumn referenciaColumn = new DataGridViewTextBoxColumn();
                referenciaColumn.Name = "NRef";
                referenciaColumn.HeaderText = "Referência";
                referenciaColumn.DataPropertyName = "NRef";

                // Adicione a coluna à DataGridView
                dataGridView1.Columns.Add(referenciaColumn);

                // Obtenha a célula específica onde deseja adicionar o controle de dropdown
                DataGridViewCell dropdownCell = dataGridView1.Rows[0].Cells["NRef"];

                // Crie um controle de dropdown (ComboBox) e atribua-o à célula
                DataGridViewComboBoxCell comboBoxCell = new DataGridViewComboBoxCell();
                comboBoxCell.Items.Add("Opção 1");
                comboBoxCell.Items.Add("Opção 2");
                comboBoxCell.Items.Add("Opção 3");
                dropdownCell = comboBoxCell;

                for (int i = 0; i < dataGridView1.Rows.Count - 1; i++)
                {
                    DataGridViewRow row = dataGridView1.Rows[i];

                    string referenciaMaterial = row.Cells["NRef"].Value?.ToString();
                    if (string.IsNullOrEmpty(referenciaMaterial))
                    {
                        continue;
                    }

                    int unidadesStr = 0;
                    if (string.IsNullOrEmpty(row.Cells["unidades"].Value?.ToString()) || !int.TryParse(row.Cells["unidades"].Value?.ToString(), out int unidades))
                    {
                        MessageBox.Show("Valor de unidades inválido na linha " + (i + 1) + ".", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        transaction.Rollback(); // Rollback the transaction
                        return;
                    }

                    if (addedReferences.Contains(referenciaMaterial))
                    {
                        MessageBox.Show("Referência duplicada encontrada: " + referenciaMaterial + ".", "Erro", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        transaction.Rollback(); // Rollback the transaction
                        return;
                    }

                    addedReferences.Add(referenciaMaterial);

                    // Create the SQL query to insert into the contem table
                    string insertContemQuery = "INSERT INTO contem (Unidades, FK_N_Referencia_Material, FK_Codigo) " +
                                               "VALUES (@Unidades, @ReferenciaMaterial, @Codigo)";

                    // Create the SqlCommand object for inserting into contem table
                    SqlCommand insertContemCommand = new SqlCommand(insertContemQuery, cn);
                    insertContemCommand.Parameters.AddWithValue("@Unidades", unidades);
                    insertContemCommand.Parameters.AddWithValue("@ReferenciaMaterial", referenciaMaterial);
                    insertContemCommand.Parameters.AddWithValue("@Codigo", codigoEncomenda);

                    // Assign the transaction to the command
                    insertContemCommand.Transaction = transaction;

                    // Execute the insert command for contem table
                    insertContemCommand.ExecuteNonQuery();
                }


                // Commit the transaction
                transaction.Commit();

                MessageBox.Show("Encomenda e detalhes adicionados com sucesso.");
            }
            catch (Exception ex)
            {
                // Rollback the transaction if an error occurs
                transaction?.Rollback();

                MessageBox.Show("Ocorreu um erro ao adicionar a encomenda e detalhes: " + ex.Message);
            }
            finally
            {
                // Close the database connection
                cn.Close();
            }
        }





        private void pictureBox2_Click(object sender, EventArgs e)
        {
            this.Close();
            AddRmv AddRmv = new AddRmv();
            AddRmv.Show();
        }

        private void numericUpDown1_ValueChanged(object sender, EventArgs e)
        {


        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            // Obter os valores do comboBoxRef e numericUpDownUnidades
            string referencia = comboBoxRef.Text;
            int unidades = (int)numericUpDownUnidades.Value;

            // Verificar se já existe uma referência ou unidade igual na dataGridView1
            bool referenciaExistente = false;
            bool unidadesExistente = false;

            foreach (DataGridViewRow row in dataGridView1.Rows)
            {
                if (row.Cells[0].Value != null && row.Cells[0].Value.ToString() == referencia)
                {
                    referenciaExistente = true;
                    break;
                }

                if (row.Cells[1].Value != null && (int)row.Cells[1].Value == unidades)
                {
                    unidadesExistente = true;
                    break;
                }
            }

            // Se não houver uma referência ou unidade igual, adicionar os valores à dataGridView1
         
            dataGridView1.Rows.Add(referencia, unidades);
           
        }



        private void comboBoxRef_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button2_Click_1(object sender, EventArgs e)
        {
                // Obter os valores da comboBoxRef e numericUpDownUnidades
                string referencia = comboBoxRef.Text;
                int unidades = (int)numericUpDownUnidades.Value;

                // Verificar se há linhas correspondentes na dataGridView1
                List<DataGridViewRow> linhasRemover = new List<DataGridViewRow>();

                foreach (DataGridViewRow row in dataGridView1.Rows)
                {
                    if (row.Cells[0].Value != null && row.Cells[0].Value.ToString() == referencia &&
                        row.Cells[1].Value != null && (int)row.Cells[1].Value == unidades)
                    {
                        linhasRemover.Add(row);
                    }
                }

                // Remover as linhas da dataGridView1
                foreach (DataGridViewRow rowRemover in linhasRemover)
                {
                    dataGridView1.Rows.Remove(rowRemover);
                }

        }

        private void dateTimeChegada_ValueChanged(object sender, EventArgs e)
        {

        }

        private void BtnLimpar_Click(object sender, EventArgs e)
        {
            textIdentificacao.Text = "";
            dateTimeChegada.Text = "";
            comboBoxRef.SelectedIndex = -1;
            numericUpDownUnidades.Value = 1;

        }
    }
}

