local vqa_data_path = {
  question_files: {
    train: '/workspace/RAVQA_v2_data/okvqa/OpenEnded_mscoco_train2014_questions.json',
    test: '/workspace/RAVQA_v2_data/okvqa/OpenEnded_mscoco_val2014_questions.json',
  },
  annotation_files: {
    train: '/workspace/RAVQA_v2_data/okvqa/mscoco_train2014_annotations.json',
    test: '/workspace/RAVQA_v2_data/okvqa/mscoco_val2014_annotations.json',
  },
};
local image_data_path = {
  train: '/workspace/RAVQA_v2_data/okvqa/train2014',
  test: '/workspace/RAVQA_v2_data/okvqa/val2014',
};
local caption_features = {
  train: '/workspace/RAVQA_v2_data/okvqa/pre-extracted_features/captions/train_predictions.json',
  valid: '/workspace/RAVQA_v2_data/okvqa/pre-extracted_features/captions/valid_predictions.json',
  test: '/workspace/RAVQA_v2_data/okvqa/pre-extracted_features/captions/test_predictions.json',
};
local VinVL_features = {
  train: '/workspace/RAVQA_v2_data/okvqa/pre-extracted_features/vinvl_output/vinvl_okvqa_trainset_full/inference/vinvl_vg_x152c4/predictions.tsv',
  test: '/workspace/RAVQA_v2_data/okvqa/pre-extracted_features/vinvl_output/vinvl_okvqa_testset_full/inference/vinvl_vg_x152c4/predictions.tsv',
};
local ocr_features = {
  "train": "/workspace/RAVQA_v2_data/okvqa/pre-extracted_features/OCR/OCR/train",
  "test": "/workspace/RAVQA_v2_data/okvqa/pre-extracted_features/OCR/OCR/valid",
  "combine_with_vinvl": true,
};
local passage_data = {
  "train": "/workspace/RAVQA_v2_data/okvqa/pre-extracted_features/passages/okvqa_train_corpus.csv",
  "full": "/workspace/RAVQA_v2_data/okvqa/pre-extracted_features/passages/okvqa_full_corpus.csv",
};
local dpr_training_annotations = {
  "train": "/workspace/RAVQA_v2_data/okvqa/pre-extracted_features/passages/retriever_train.json",
  "valid": "/workspace/RAVQA_v2_data/okvqa/pre-extracted_features/passages/retriever_testdev.json",
  "test": "/workspace/RAVQA_v2_data/okvqa/pre-extracted_features/passages/retriever_test.json",
};

local okvqa_data_pipeline = {
  name: 'OKVQADataPipeline',
  regenerate: false,
  do_inspect: true,
  transforms: {
    'input:LoadVinVLFeatures': {
      transform_name: 'LoadVinVLFeatures',
      regenerate: false,
      cache: true,
      setup_kwargs: {
        VinVL_features: VinVL_features,
      },
    },
    'input:LoadOscarCaptionFeatures': {
      transform_name: 'LoadOscarCaptionFeatures',
      regenerate: false,
      cache: true,
      setup_kwargs: {
        caption_features: caption_features,
      },
    },
    'input:LoadGoogleOCRFeatures': {
      transform_name: 'LoadGoogleOCRFeatures',
      input_node: 'input:LoadVinVLFeatures',
      regenerate: false,
      cache: true,
      setup_kwargs: {
        ocr_features: ocr_features,
      }
    },
    'process:LoadOKVQAData': {
      input_node: [
        'input:LoadVinVLFeatures',
        'input:LoadOscarCaptionFeatures',
        'input:LoadGoogleOCRFeatures',
      ],
      transform_name: 'LoadOKVQAData',
      regenerate: false,
      cache: true,
      setup_kwargs: {
        vqa_data_path: vqa_data_path,
        image_data_path: image_data_path,
        add_images: false,
        add_caption_features: true,
        add_OCR_features: true,
        add_VinVL_features: true,
      },
    },
    'input:LoadGoogleSearchPassageData': {
      transform_name: 'LoadGoogleSearchPassageData',
      regenerate: false,
      cache: true,
      setup_kwargs: {
        passage_data_path: passage_data,
        use_full_split: true,
      },
    },
    'input:LoadGoogleSearchAnnotations': {
      transform_name: 'LoadGoogleSearchAnnotations',
      input_node: [
        'input:LoadGoogleSearchPassageData',
        'process:LoadOKVQAData',
      ],
      regenerate: false,
      cache: true,
      setup_kwargs: {
        annotations_path: dpr_training_annotations,
      },
    },
    'process:PrepareGoogleSearchPassages':{
      transform_name: 'PrepareGoogleSearchPassages',
      input_node: [
        'input:LoadGoogleSearchPassageData',
      ],
      regenerate: false,
      cache: true,
      setup_kwargs: {},
    },
  },
};

{
  okvqa_data_pipeline: okvqa_data_pipeline,
}
