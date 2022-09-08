classdef feature_class < handle & matlab.mixin.Copyable
    properties
        x % x and y start from 0, r and c in feature_data start from 1
        y
        a
        b
        c
        scl
        ori
        d
        descr
        type
        category
        fwd_match
        bck_match
        mdl_match
        img_pt
        mdl_pt
        feature_data
    end
    
    methods
        function A = feature_class()
            A.img_pt = struct('x', -1, 'y', -1);
            A.mdl_pt = struct('x', -1, 'y', -1);
        end
    end
end