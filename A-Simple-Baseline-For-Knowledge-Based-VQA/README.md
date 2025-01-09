## Install
First, please install the necessary dependencies:
```bash
pip install -r requirements.txt
```
## Usage
First, download the LLaMA weights and convert them to Huggingface format

To run the code use the run_main.sh script!
```bash
python main.py \
    --dataset ok_vqa \
    --evaluation_set val \
    --train_annotations_path annotations/ok_vqa/train_annots_fixed.csv.zip \
    --val_annotations_path annotations/ok_vqa/val_annots_fixed.csv.zip \
    --test_annotations_path None \
    --train_images_dir /path_to_the_train_images/ \
    --val_images_dir /path_to_the_val_images/ \
    --test_images_dir None \
    --n_shots 10 \
    --k_ensemble 5 \
    --no_of_captions 9 \
    --use_mcan_examples False \
    --mcan_examples_path mcan_examples/ok_vqa/examples.json \
    --llama_path meta-llama/Llama-2-13b-hf \
    --train_captions_path question_related_captions/ok_vqa/train_data_qr_captions_csv \
    --val_captions_path question_related_captions/ok_vqa/val_data_qr_captions_csv \
    --test_captions_path None \
    --blip_train_question_embedds_path blip_embedds/ok_vqa/blip_normalized_q_embedds/blip_train_question_embedds.csv.zip \
    --blip_train_image_embedds_path blip_embedds/ok_vqa/blip_normalized_i_embedds/blip_train_image_embedds.csv.zip \
    --blip_val_question_embedds_path blip_embedds/ok_vqa/blip_normalized_q_embedds/blip_val_question_embedds.csv.zip \
    --blip_val_image_embedds_path blip_embedds/ok_vqa/blip_normalized_i_embedds/blip_val_image_embedds.csv.zip \
    --path_to_save_preds results/ok_vqa_val_without_mcan_llama2.csv
```
*Note that you must include the paths to the train, val, and test images

## Results
See the "results" folder for the results reported in the main paper
