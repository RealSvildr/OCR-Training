import os
import argparse

def create_labels_txt(dir_path):
    if not dir_path.endswith("/"):
        dir_path += "/"

    # Abrir o arquivo de saída em modo de escrita
    with open(dir_path + 'labels.txt', 'w') as f:
        # Listar todos os arquivos no diretório
        for file_name in os.listdir(dir_path):
            if file_name == 'labels.txt':
                continue;
        
            file_path = os.path.join(dir_path, file_name)

            # Verificar se é um arquivo (e não uma subpasta)
            if os.path.isfile(file_path):
                text = file_name.split('_')[0]
                # Escrever o nome do arquivo no arquivo de saída, pulando uma linha
                f.write(file_name + '\t' + text + '\n')



if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--dir_path', required=True, help='Path of the images')

    opt = parser.parse_args()
    create_labels_txt(opt.dir_path)


